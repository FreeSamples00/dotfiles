import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { ReadonlyFooterDataProvider } from "@earendil-works/pi-coding-agent";
import { getAgentDir } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

// ── Types ───────────────────────────────────────────────────────────────────

type ContentToken = "pwd" | "context" | "cost" | "model" | "statuses";
type StaticToken = "<flex>" | "<bar>" | "<space>";
type SegmentToken = ContentToken | StaticToken;
type CollapseLevel = "full" | "short" | "minimal";

interface CompactFooterSettings {
  /** Segment order. Listed segments are shown; omitted ones are hidden. */
  order?: SegmentToken[];
  /** Separator between segments (default " │ ") */
  separator?: string;
  /** Drop priority (lower = drops first). Default: pwd 1, cost 2, statuses 3, model 4, context 5 */
  priority?: Record<string, number>;
  /** Collapse thresholds by segment. Keys are terminal widths below which the form activates. */
  collapse?: Record<string, { short?: number; minimal?: number }>;
}

// ── Defaults ────────────────────────────────────────────────────────────────

const DEFAULT_ORDER: SegmentToken[] = [
  "pwd",
  "context",
  "cost",
  "model",
  "statuses",
];

const DEFAULT_PRIORITY: Record<string, number> = {
  pwd: 1,
  cost: 2,
  statuses: 3,
  model: 4,
  context: 5,
};

const DEFAULT_COLLAPSE: Record<string, { short?: number; minimal?: number }> = {
  pwd: { short: 100, minimal: 60 },
  context: { short: 70 },
  statuses: { short: 90 },
  model: { short: 80 },
};

// ── Settings ────────────────────────────────────────────────────────────────

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

// ── Segment builders ────────────────────────────────────────────────────────

function buildPwdSegment(
  ctx: ExtensionContext,
  footerData: ReadonlyFooterDataProvider,
  theme: { fg: (color: string, text: string) => string },
  level: CollapseLevel,
): string | undefined {
  let pwd = ctx.sessionManager.getCwd();
  const home =
    typeof process !== "undefined"
      ? process.env.HOME || process.env.USERPROFILE
      : undefined;
  const branch = footerData.getGitBranch();

  if (level === "full") {
    // Home-relative path
    if (home && pwd.startsWith(home)) pwd = `~${pwd.slice(home.length)}`;
    const pwdPart = theme.fg("muted", pwd);
    const branchPart = branch ? theme.fg("accent", ` (${branch})`) : "";
    return pwdPart + branchPart;
  }

  if (level === "short") {
    // Basename + branch
    const parts = pwd.split("/");
    const base = parts[parts.length - 1] || pwd;
    const pwdPart = theme.fg("muted", base);
    const branchPart = branch ? theme.fg("accent", ` (${branch})`) : "";
    return pwdPart + branchPart;
  }

  // minimal: basename only, no branch
  const parts = pwd.split("/");
  const base = parts[parts.length - 1] || pwd;
  return theme.fg("muted", base);
}

function buildContextSegment(
  ctx: ExtensionContext,
  theme: { fg: (color: string, text: string) => string },
  level: CollapseLevel,
): string | undefined {
  const contextUsage = ctx.getContextUsage();
  if (!contextUsage) return undefined;

  const pctValue = contextUsage.percent ?? 0;

  if (level === "short") {
    // Percentage only
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
    return theme.fg(color, `${prefix}${Math.round(pctValue)}%`);
  }

  // Full: used/total
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

  return theme.fg(color, `${prefix}${usedStr}/${windowStr}`);
}

function buildCostSegment(
  ctx: ExtensionContext,
  theme: { fg: (color: string, text: string) => string },
): string | undefined {
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
  if (!totalCost) return undefined;
  return theme.fg("warning", `$${totalCost.toFixed(2)}`);
}

function buildModelSegment(
  ctx: ExtensionContext,
  theme: { fg: (color: string, text: string) => string },
  level: CollapseLevel,
): string | undefined {
  const modelId = ctx.model?.name || ctx.model?.id || "no-model";
  const modelPart = theme.fg("toolTitle", modelId);

  // Append thinking level in dim color; collapse drops it first
  if (level === "full" && currentThinkingLevel && currentThinkingLevel !== "off") {
    return modelPart + theme.fg("dim", ` [${currentThinkingLevel}]`);
  }

  return modelPart;
}

function buildStatusesSegment(
  footerData: ReadonlyFooterDataProvider,
  level: CollapseLevel,
): string | undefined {
  const statuses = footerData.getExtensionStatuses();
  if (statuses.size === 0) return undefined;

  const compact = level !== "full";
  const parts: string[] = [];

  for (const [key, text] of Array.from(statuses.entries()).sort(([a], [b]) =>
    a.localeCompare(b),
  )) {
    // In compact mode, prefer :compact variant if available
    if (compact) {
      const compactKey = `${key}:compact`;
      const compactText = statuses.get(compactKey);
      if (compactText) {
        parts.push(sanitizeStatusText(compactText));
        continue;
      }
    }
    // Skip :compact entries when rendering full mode
    if (key.endsWith(":compact")) continue;
    parts.push(sanitizeStatusText(text));
  }

  return parts.join(" ") || undefined;
}

// ── Segment dispatch ────────────────────────────────────────────────────────

function isStaticToken(token: string): token is StaticToken {
  return token.startsWith("<");
}

function buildSegment(
  token: ContentToken,
  ctx: ExtensionContext,
  footerData: ReadonlyFooterDataProvider,
  theme: { fg: (color: string, text: string) => string },
  level: CollapseLevel,
): string | undefined {
  switch (token) {
    case "pwd":
      return buildPwdSegment(ctx, footerData, theme, level);
    case "context":
      return buildContextSegment(ctx, theme, level);
    case "cost":
      return buildCostSegment(ctx, theme);
    case "model":
      return buildModelSegment(ctx, theme, level);
    case "statuses":
      return buildStatusesSegment(footerData, level);
  }
}

function determineLevel(
  token: string,
  collapse: Record<string, { short?: number; minimal?: number }>,
  width: number,
): CollapseLevel {
  const c = collapse[token];
  if (!c) return "full";
  if (c.minimal !== undefined && width < c.minimal) return "minimal";
  if (c.short !== undefined && width < c.short) return "short";
  return "full";
}

/** What's the next more compact level? */
function nextLevel(current: CollapseLevel): CollapseLevel | null {
  if (current === "full") return "short";
  if (current === "short") return "minimal";
  return null; // already minimal
}

// ── Layout ───────────────────────────────────────────────────────────────────

interface Entry {
  token: SegmentToken;
  text: string;
  width: number; // -1 for flex (computed later)
  priority: number;
  droppable: boolean;
  level: CollapseLevel; // current collapse level of this entry
}

function layoutFooter(
  order: SegmentToken[],
  ctx: ExtensionContext,
  footerData: ReadonlyFooterDataProvider,
  theme: { fg: (color: string, text: string) => string },
  width: number,
  separator: string,
  priorityMap: Record<string, number>,
  collapseMap: Record<string, { short?: number; minimal?: number }>,
): string[] {
  const sepWidth = visibleWidth(separator);

  // 1. Build entries with collapse levels
  const entries: Entry[] = [];

  for (const token of order) {
    if (token === "<flex>") {
      entries.push({
        token,
        text: "",
        width: -1,
        priority: Infinity,
        droppable: false,
        level: "full",
      });
    } else if (token === "<bar>") {
      entries.push({
        token,
        text: theme.fg("borderMuted", "─"),
        width: 1,
        priority: 0,
        droppable: true,
        level: "full",
      });
    } else if (token === "<space>") {
      entries.push({
        token,
        text: "  ",
        width: 2,
        priority: 0,
        droppable: true,
        level: "full",
      });
    } else {
      const level = determineLevel(token, collapseMap, width);
      const text = buildSegment(token, ctx, footerData, theme, level);
      if (text !== undefined) {
        entries.push({
          token,
          text,
          width: visibleWidth(text),
          priority: priorityMap[token] ?? Infinity,
          droppable: true,
          level,
        });
      }
    }
  }

  // 2. Split into sections by flex (for separator logic)
  function buildSections(): string[][] {
    const sections: string[][] = [];
    let current: string[] = [];
    for (const entry of entries) {
      if (entry.token === "<flex>") {
        sections.push(current);
        current = [];
      } else if (entry.text) {
        current.push(entry.text);
      }
    }
    sections.push(current);
    return sections;
  }

  function calcSectionsWidth(sections: string[][]): number {
    let total = 0;
    for (const section of sections) {
      for (const text of section) {
        total += visibleWidth(text);
      }
      if (section.length > 1) {
        total += (section.length - 1) * sepWidth;
      }
    }
    return total;
  }

  function flexCount(): number {
    return entries.filter((e) => e.token === "<flex>").length;
  }

  // 3. Collapse-before-drop: try collapsing the lowest-priority segment
  //    before removing it entirely. Only drop if already minimal.
  function collapseOrDropLowestPriority(
    ctx: ExtensionContext,
    footerData: ReadonlyFooterDataProvider,
    theme: { fg: (color: string, text: string) => string },
  ): boolean {
    // Find the lowest-priority droppable entry
    let lowestIdx = -1;
    let lowestPri = Infinity;
    for (let i = 0; i < entries.length; i++) {
      if (entries[i]!.droppable && entries[i]!.priority < lowestPri) {
        lowestPri = entries[i]!.priority;
        lowestIdx = i;
      }
    }
    if (lowestIdx === -1) return false;

    const entry = entries[lowestIdx]!;

    // Try collapsing one level further
    const next = nextLevel(entry.level);
    if (next !== null && !isStaticToken(entry.token)) {
      const newText = buildSegment(
        entry.token as ContentToken,
        ctx,
        footerData,
        theme,
        next,
      );
      if (newText !== undefined) {
        entry.text = newText;
        entry.width = visibleWidth(newText);
        entry.level = next;
        return true;
      }
    }

    // Already minimal or can't collapse further — drop it
    entries.splice(lowestIdx, 1);
    return true;
  }

  const hasFlex = flexCount() > 0;

  if (hasFlex) {
    let sections = buildSections();
    while (calcSectionsWidth(sections) > width && collapseOrDropLowestPriority(ctx, footerData, theme)) {
      sections = buildSections();
    }

    const totalFixedWidth = calcSectionsWidth(sections);
    const flexSpace = Math.max(0, width - totalFixedWidth);
    const numFlex = flexCount();
    const perFlex = Math.floor(flexSpace / numFlex);
    const remainder = flexSpace - perFlex * numFlex;

    const joinedSections = sections.map((s) => s.join(separator));
    const parts: string[] = [];
    let flexIdx = 0;

    for (let i = 0; i < joinedSections.length; i++) {
      if (joinedSections[i]) parts.push(joinedSections[i]!);
      if (flexIdx < numFlex) {
        const extra = flexIdx < remainder ? 1 : 0;
        parts.push(" ".repeat(perFlex + extra));
        flexIdx++;
      }
    }

    return [truncateToWidth(parts.join(""), width, theme.fg("dim", "…"))];
  }

  // No flex — fit on one line by collapsing/dropping, then wrap as last resort
  let sections = buildSections();
  while (calcSectionsWidth(sections) > width && collapseOrDropLowestPriority(ctx, footerData, theme)) {
    sections = buildSections();
  }

  // Single section (no flex), join with separator
  const allTexts = entries.filter((e) => e.text).map((e) => e.text);
  if (allTexts.length === 0) return [];

  // Try to fit on one line
  const oneLine = allTexts.join(separator);
  if (visibleWidth(oneLine) <= width) {
    return [truncateToWidth(oneLine, width, theme.fg("dim", "…"))];
  }

  // Wrap: fill each line as much as possible
  const lines: string[] = [];
  let currentLine: string[] = [];
  let currentWidth = 0;

  for (const text of allTexts) {
    const textWidth = visibleWidth(text);
    const needed = textWidth + (currentLine.length > 0 ? sepWidth : 0);
    if (currentWidth + needed <= width) {
      currentLine.push(text);
      currentWidth += needed;
    } else {
      if (currentLine.length > 0) lines.push(currentLine.join(separator));
      if (textWidth > width) {
        lines.push(truncateToWidth(text, width, "…"));
        currentLine = [];
        currentWidth = 0;
      } else {
        currentLine = [text];
        currentWidth = textWidth;
      }
    }
  }
  if (currentLine.length > 0) lines.push(currentLine.join(separator));

  return lines.map((line) =>
    truncateToWidth(line, width, theme.fg("dim", "…")),
  );
}

// ── Install ─────────────────────────────────────────────────────────────────

// ── Thinking level state ──────────────────────────────────────────────────────

let currentThinkingLevel: string = "off";

// ── Install ─────────────────────────────────────────────────────────────────

let cleanup: (() => void) | undefined;

export default function (pi: ExtensionAPI) {
  pi.on("thinking_level_select", async (event, _ctx) => {
    currentThinkingLevel = event.level;
  // Footer re-renders on next paint automatically
  });

  pi.on("session_start", async (_event, ctx) => {
    currentThinkingLevel = pi.getThinkingLevel() ?? "off";
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
          const priorityMap = {
            ...DEFAULT_PRIORITY,
            ...(settings.priority ?? {}),
          };
          const collapseMap = {
            ...DEFAULT_COLLAPSE,
            ...(settings.collapse ?? {}),
          };
          return layoutFooter(
            order,
            ctx,
            footerData,
            theme,
            width,
            separator,
            priorityMap,
            collapseMap,
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
    currentThinkingLevel = "off";
    cleanup?.();
    cleanup = undefined;
  });

  pi.on("session_shutdown", () => {
    currentThinkingLevel = "off";
    cleanup?.();
    cleanup = undefined;
  });
}
