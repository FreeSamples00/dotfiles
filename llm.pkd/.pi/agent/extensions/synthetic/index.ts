import type { AuthStorage, ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { getAgentDir } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { SYNTHETIC_MODELS } from "./models";
import {
  QuotaStore,
  fetchQuotas,
  parseQuotaHeader,
  type QuotasResponse,
} from "./quotas";
import { formatStatus } from "./usage-status";

interface SyntheticSettings {
  hideStatuses?: Record<string, boolean>;
}

/**
 * Read the `synthetic` section from settings.json.
 * hideStatuses maps short labels ("week", "5h", "search", "tools") to true to hide them.
 */
function readSyntheticSettings(): SyntheticSettings {
  try {
    const settingsPath = join(getAgentDir(), "settings.json");
    const raw = readFileSync(settingsPath, "utf-8");
    const parsed = JSON.parse(raw);
    return parsed?.synthetic ?? {};
  } catch {
    return {};
  }
}

const EXTENSION_ID = "synthetic-usage";
const QUOTA_REFRESH_INTERVAL_MS = 60_000;

async function getSyntheticApiKey(
  authStorage: AuthStorage,
): Promise<string | undefined> {
  const key = await authStorage.getApiKey("synthetic");
  return key ?? process.env.SYNTHETIC_API_KEY;
}

function registerSyntheticProvider(pi: ExtensionAPI): void {
  pi.registerProvider("synthetic", {
    baseUrl: "https://api.synthetic.new/openai/v1",
    apiKey: "SYNTHETIC_API_KEY",
    api: "openai-completions",
    headers: {
      Referer: "https://pi.dev",
      "X-Title": "synthetic-extension",
    },
    models: SYNTHETIC_MODELS,
  });
}

function clearStatus(ctx: ExtensionContext): void {
  if (!ctx.hasUI) return;
  ctx.ui.setStatus(EXTENSION_ID, undefined);
  ctx.ui.setStatus(`${EXTENSION_ID}:compact`, undefined);
}

function setStatuses(
  ctx: ExtensionContext,
  snapshot: QuotaSnapshot | undefined,
  hiddenLabels: Set<string>,
): void {
  if (!ctx.hasUI) return;
  ctx.ui.setStatus(EXTENSION_ID, formatStatus(ctx, snapshot, hiddenLabels, false));
  ctx.ui.setStatus(`${EXTENSION_ID}:compact`, formatStatus(ctx, snapshot, hiddenLabels, true));
}

function renderFromStoreOrRefresh(
  ctx: ExtensionContext,
  quotaStore: QuotaStore,
  authStorage: AuthStorage | undefined,
  hiddenLabels: Set<string>,
): void {
  if (ctx.model?.provider !== "synthetic") {
    clearStatus(ctx);
    return;
  }

  const snapshot = quotaStore.getSnapshot();
  if (snapshot) {
    setStatuses(ctx, snapshot, hiddenLabels);
  } else {
    if (ctx.hasUI)
      ctx.ui.setStatus(
        EXTENSION_ID,
        ctx.ui.theme.fg("dim", "loading usage..."),
      );
    if (authStorage) {
      getSyntheticApiKey(authStorage).then((apiKey) => {
        if (!apiKey) return;
        quotaStore.refreshFromApi(() => fetchQuotas(apiKey)).then((snap) => {
          if (snap && ctx.hasUI) {
            setStatuses(ctx, snap, hiddenLabels);
          }
        });
      });
    }
  }
}

export default function (pi: ExtensionAPI) {
  registerSyntheticProvider(pi);

  const quotaStore = new QuotaStore();
  let currentAuthStorage: AuthStorage | undefined;
  let refreshTimer: ReturnType<typeof setInterval> | undefined;
  const getHiddenStatuses = (): Set<string> => {
    const hidden = readSyntheticSettings().hideStatuses;
    if (!hidden) return new Set();
    return new Set(Object.entries(hidden).filter(([, v]) => v).map(([k]) => k));
  };

  function startRefreshTimer(ctx: ExtensionContext): void {
    stopRefreshTimer();
    if (ctx.model?.provider !== "synthetic") return;
    refreshTimer = setInterval(() => {
      if (!currentAuthStorage) return;
      getSyntheticApiKey(currentAuthStorage).then((apiKey) => {
        if (!apiKey) return;
        quotaStore.refreshFromApi(() => fetchQuotas(apiKey)).then((snap) => {
          if (snap && ctx.hasUI) {
            setStatuses(ctx, snap, getHiddenStatuses());
          }
        });
      });
    }, QUOTA_REFRESH_INTERVAL_MS);
  }

  function stopRefreshTimer(): void {
    if (refreshTimer !== undefined) {
      clearInterval(refreshTimer);
      refreshTimer = undefined;
    }
  }

  pi.on("after_provider_response", (event, ctx) => {
    if (ctx.model?.provider !== "synthetic") return;
    const quotas = parseQuotaHeader(event.headers);
    if (quotas) {
      quotaStore.ingest(quotas, "header");
      const snapshot = quotaStore.getSnapshot();
      if (snapshot && ctx.hasUI) {
        setStatuses(ctx, snapshot, getHiddenStatuses());
      }
    }
  });

  pi.on("session_start", async (_event, ctx) => {
    quotaStore.clear();
    currentAuthStorage = ctx.modelRegistry.authStorage;

    if (ctx.model?.provider === "synthetic") {
      const apiKey = await getSyntheticApiKey(currentAuthStorage);
      if (apiKey) {
        const snap = await quotaStore.refreshFromApi(() =>
          fetchQuotas(apiKey),
        );
        if (snap && ctx.hasUI) {
          setStatuses(ctx, snap, getHiddenStatuses());
        }
      }
      startRefreshTimer(ctx);
    }
  });

  pi.on("model_select", (_event, ctx) => {
    if (ctx.model?.provider === "synthetic") {
      renderFromStoreOrRefresh(ctx, quotaStore, currentAuthStorage, getHiddenStatuses());
      startRefreshTimer(ctx);
    } else {
      clearStatus(ctx);
      stopRefreshTimer();
    }
  });

  pi.on("agent_end", (_event, ctx) => {
    renderFromStoreOrRefresh(ctx, quotaStore, currentAuthStorage, getHiddenStatuses());
  });

  pi.on("turn_end", (_event, ctx) => {
    renderFromStoreOrRefresh(ctx, quotaStore, currentAuthStorage, getHiddenStatuses());
  });

  pi.on("session_before_switch", (_event, ctx) => {
    clearStatus(ctx);
    stopRefreshTimer();
    quotaStore.clear();
    currentAuthStorage = undefined;
  });

  pi.on("session_shutdown", () => {
    stopRefreshTimer();
    quotaStore.clear();
    currentAuthStorage = undefined;
  });
}
