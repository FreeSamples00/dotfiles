import type { AuthStorage, ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { SYNTHETIC_MODELS } from "./models";
import {
  QuotaStore,
  fetchQuotas,
  parseQuotaHeader,
  type QuotasResponse,
} from "./quotas";
import { formatStatus } from "./usage-status";
import { installCompactFooter } from "./compact-footer";

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
}

function renderFromStoreOrRefresh(
  ctx: ExtensionContext,
  quotaStore: QuotaStore,
  authStorage: AuthStorage | undefined,
): void {
  if (ctx.model?.provider !== "synthetic") {
    clearStatus(ctx);
    return;
  }

  const snapshot = quotaStore.getSnapshot();
  if (snapshot) {
    const status = formatStatus(ctx, snapshot);
    if (ctx.hasUI) ctx.ui.setStatus(EXTENSION_ID, status);
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
            const status = formatStatus(ctx, snap);
            ctx.ui.setStatus(EXTENSION_ID, status);
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
  let removeCompactFooter: (() => void) | undefined;

  function startRefreshTimer(ctx: ExtensionContext): void {
    stopRefreshTimer();
    if (ctx.model?.provider !== "synthetic") return;
    refreshTimer = setInterval(() => {
      if (!currentAuthStorage) return;
      getSyntheticApiKey(currentAuthStorage).then((apiKey) => {
        if (!apiKey) return;
        quotaStore.refreshFromApi(() => fetchQuotas(apiKey)).then((snap) => {
          if (snap && ctx.hasUI) {
            const status = formatStatus(ctx, snap);
            ctx.ui.setStatus(EXTENSION_ID, status);
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
        const status = formatStatus(ctx, snapshot);
        ctx.ui.setStatus(EXTENSION_ID, status);
      }
    }
  });

  pi.on("session_start", async (_event, ctx) => {
    quotaStore.clear();
    currentAuthStorage = ctx.modelRegistry.authStorage;

    // Install compact one-line footer
    removeCompactFooter?.();
    removeCompactFooter = installCompactFooter(pi, ctx);

    if (ctx.model?.provider === "synthetic") {
      const apiKey = await getSyntheticApiKey(currentAuthStorage);
      if (apiKey) {
        const snap = await quotaStore.refreshFromApi(() =>
          fetchQuotas(apiKey),
        );
        if (snap && ctx.hasUI) {
          const status = formatStatus(ctx, snap);
          ctx.ui.setStatus(EXTENSION_ID, status);
        }
      }
      startRefreshTimer(ctx);
    }
  });

  pi.on("model_select", (_event, ctx) => {
    if (ctx.model?.provider === "synthetic") {
      renderFromStoreOrRefresh(ctx, quotaStore, currentAuthStorage);
      startRefreshTimer(ctx);
    } else {
      clearStatus(ctx);
      stopRefreshTimer();
    }
  });

  pi.on("agent_end", (_event, ctx) => {
    renderFromStoreOrRefresh(ctx, quotaStore, currentAuthStorage);
  });

  pi.on("turn_end", (_event, ctx) => {
    renderFromStoreOrRefresh(ctx, quotaStore, currentAuthStorage);
  });

  pi.on("session_before_switch", (_event, ctx) => {
    clearStatus(ctx);
    stopRefreshTimer();
    removeCompactFooter?.();
    quotaStore.clear();
    currentAuthStorage = undefined;
  });

  pi.on("session_shutdown", () => {
    stopRefreshTimer();
    removeCompactFooter?.();
    quotaStore.clear();
    currentAuthStorage = undefined;
  });
}
