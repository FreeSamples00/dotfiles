import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { ReadonlyFooterDataProvider } from "@earendil-works/pi-coding-agent";
import { getAgentDir } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

// ── Settings ────────────────────────────────────────────────────────────────

type SegmentToken =
  | "pwd"
  | "context"
  | "cost"
  | "model"
  | "statuses"
  | "<flex>"
  | "<bar>"
  | "<space>";

const DEFAULT_ORDER: SegmentToken[] = [
  "pwd",
  "context",
  "cost",
  "model",
  "statuses",
];

interface CompactFooterSettings {
  /** Segment order. Listed segments are shown; omitted ones are hidden. */
  order?: SegmentToken[];
  /** Separator between segments (default " │ ") */
  separator?: string;
}

function readSettings(): CompactFooterSettings {
  try {
    const settingsPath = join(getAgentDir(), "settings.json");
    const raw = readFileSync(settingsPath, "utf-8");
    const parsed = JSON.parse(raw);
    return parsed?.["compact-footer"] ?? {};
  } catch {
    return {};
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────────

function formatTokens(count: number): string {
  if (count < 1000) return count.toString();
  if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
  if (count < 1000000) return `${Math.round(count / 1000)}k`;
  if (count < 10000000) return `${(count / 1000000).toFixed(1)}M`;
  return `${Math.round(count / 1000000)}M`;
}

function sanitizeStatusText(text: string): string {
  return text
    .replace(/[\r\n\t]/g, " ")
    .replace(/ +/g, " ")
    .trim();
}

// ── Segment builder ─────────────────────────────────────────────────────────

/**
 * Build each content segment as a tagged entry.
 * Static tokens (<flex>, <bar>, <space>) are produced by the layout step.
 */
function buildContentSegments(
  ctx: ExtensionContext,
  footerData: ReadonlyFooterDataProvider,
  theme: { fg: (color: string, text: string) => string },
): Map<SegmentToken, string> {
  const segments = new Map<SegmentToken, string>();

  // PWD + branch
  let pwd = ctx.sessionManager.getCwd();
  const home =
    typeof process !== "undefined"
      ? process.env.HOME || process.env.USERPROFILE
      : undefined;
  if (home && pwd.startsWith(home)) pwd = `~${pwd.slice(home.length)}`;
  const branch = footerData.getGitBranch();
  const pwdPart = theme.fg("muted", pwd);
  const branchPart = branch ? theme.fg("accent", ` (${branch})`) : "";
  segments.set("pwd", pwdPart + branchPart);

  // Cost
  let totalCost = 0;
  for (const entry of ctx.sessionManager.getEntries()) {
    if (
      entry.type === "message" &&
      (entry.message as { role: string }).role === "assistant"
    ) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const m = entry.message as any;
      totalCost += m.usage?.cost?.total ?? 0;
    }
  }
  if (totalCost) {
    segments.set("cost", theme.fg("warning", `$${totalCost.toFixed(3)}`));
  }

  // Context usage
  const contextUsage = ctx.getContextUsage();
  if (contextUsage) {
    const pctValue = contextUsage.percent ?? 0;
    const windowStr = formatTokens(contextUsage.contextWindow);
    let usedStr: string;
    if (contextUsage.percent !== null && contextUsage.contextWindow > 0) {
      const usedTokens = Math.round(
        (pctValue / 100) * contextUsage.contextWindow,
      );
      usedStr = formatTokens(usedTokens);
    } else {
      usedStr = "?";
    }

    let color: string;
    let prefix = "";
    if (pctValue >= 80) {
      color = "error";
      prefix = "⚠ ";
    } else if (pctValue >= 50) {
      color = "error";
    } else {
      color = "dim";
    }

    segments.set("context", theme.fg(color, `${prefix}${usedStr}/${windowStr}`));
  }

  // Model
  const modelId = ctx.model?.name || ctx.model?.id || "no-model";
  segments.set("model", theme.fg("toolTitle", modelId));

  // Extension statuses (combined into one segment)
  const statuses = footerData.getExtensionStatuses();
  if (statuses.size > 0) {
    const parts = Array.from(statuses.entries())
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([, text]) => sanitizeStatusText(text));
    segments.set("statuses", parts.join(" "));
  }

  return segments;
}

// ── Layout ──────────────────────────────────────────────────────────────────

/**
 * Resolve the ordered segment list, then lay out with flex expansion.
 */
function layoutFooter(
  order: SegmentToken[],
  content: Map<SegmentToken, string>,
  width: number,
  separator: string,
  theme: { fg: (color: string, text: string) => string },
): string[] {
  const sepWidth = visibleWidth(separator);
  const spaceWidth = 2; // <space> token width

  // Build the ordered list of (token, renderedText)
  type Entry = { token: SegmentToken; text: string; width: number };
  const entries: Entry[] = [];

  for (const token of order) {
    if (token === "<flex>") {
      entries.push({ token, text: "", width: -1 }); // -1 = flex marker
    } else if (token === "<bar>") {
      const text = theme.fg("borderMuted", "─");
      entries.push({ token, text, width: 1 });
    } else if (token === "<space>") {
      entries.push({ token, text: " ".repeat(spaceWidth), width: spaceWidth });
    } else {
      const text = content.get(token);
      if (text) {
        entries.push({ token, text, width: visibleWidth(text) });
      }
      // If content missing (e.g. no cost yet), skip silently
    }
  }

  // Count flex tokens
  const flexCount = entries.filter((e) => e.token === "<flex>").length;

  // Compute total fixed width (segments + separators between non-flex entries)
  // For flex calculation, treat the whole line as one row (no wrapping when flex present)
  if (flexCount > 0) {
    // Calculate total fixed width including separators
    let totalFixedWidth = 0;
    for (let i = 0; i < entries.length; i++) {
      if (entries[i]!.width >= 0) {
        totalFixedWidth += entries[i]!.width;
      }
    }
    // Add separator widths (between all adjacent non-empty entries)
    for (let i = 1; i < entries.length; i++) {
      if (entries[i]!.text !== "" && entries[i - 1]!.text !== "") {
        totalFixedWidth += sepWidth;
      } else if (
        entries[i]!.token === "<flex>" &&
        entries[i - 1]!.text !== ""
      ) {
        // Separator before flex is absorbed by flex
      } else if (
        entries[i]!.text !== "" &&
        entries[i - 1]!.token === "<flex>"
      ) {
        // Separator after flex is absorbed by flex
      }
    }

    const available = Math.max(0, width - totalFixedWidth);
    const perFlex = Math.floor(available / flexCount);
    const remainder = available - perFlex * flexCount;

    // Assign flex widths
    let flexIndex = 0;
    for (const entry of entries) {
      if (entry.token === "<flex>") {
        const extra = flexIndex < remainder ? 1 : 0;
        entry.text = " ".repeat(perFlex + extra);
        entry.width = perFlex + extra;
        flexIndex++;
      }
    }

    // Join — no separators around flex tokens
    const parts: string[] = [];
    for (let i = 0; i < entries.length; i++) {
      if (entries[i]!.text === "") continue; // skip empty flex placeholders (shouldn't happen after fill)
      if (
        i > 0 &&
        entries[i]!.token !== "<flex>" &&
        entries[i - 1]!.token !== "<flex>" &&
        entries[i - 1]!.text !== "" &&
        // Only add separator if previous was a real content entry
        entries[i]!.text !== ""
      ) {
        parts.push(separator);
      }
      parts.push(entries[i]!.text);
    }
    return [truncateToWidth(parts.join(""), width, theme.fg("dim", "…"))];
  }

  // No flex — use wrapping layout
  const lines: string[] = [];
  let currentLine: string[] = [];
  let currentWidth = 0;

  for (const entry of entries) {
    const needed = entry.width + (currentLine.length > 0 ? sepWidth : 0);
    if (currentWidth + needed <= width) {
      currentLine.push(entry.text);
      currentWidth += needed;
    } else {
      if (currentLine.length > 0) {
        lines.push(currentLine.join(separator));
      }
      if (entry.width > width) {
        lines.push(truncateToWidth(entry.text, width, "…"));
        currentLine = [];
        currentWidth = 0;
      } else {
        currentLine = [entry.text];
        currentWidth = entry.width;
      }
    }
  }

  if (currentLine.length > 0) {
    lines.push(currentLine.join(separator));
  }

  return lines;
}

// ── Install ─────────────────────────────────────────────────────────────────

let cleanup: (() => void) | undefined;

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;

    cleanup?.();

    let installed = true;

    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsub = footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: () => {
          unsub();
          installed = false;
        },
        invalidate() {
          // No cached state — we recompute every render
        },
        render(width: number): string[] {
          if (!installed) return [];
          const settings = readSettings();
          const order = settings.order ?? DEFAULT_ORDER;
          const separator = settings.separator ?? " │ ";
          const content = buildContentSegments(ctx, footerData, theme);
          const lines = layoutFooter(order, content, width, separator, theme);
          return lines.map((line) =>
            truncateToWidth(line, width, theme.fg("dim", "…")),
          );
        },
      };
    });

    cleanup = () => {
      if (installed) {
        installed = false;
        ctx.ui.setFooter(undefined);
      }
    };
  });

  pi.on("session_before_switch", (_event, ctx) => {
    cleanup?.();
    cleanup = undefined;
  });

  pi.on("session_shutdown", () => {
    cleanup?.();
    cleanup = undefined;
  });
}
