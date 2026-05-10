import type {
  ExtensionContext,
  ReadonlyFooterDataProvider,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const SEPARATOR = " │ ";

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

/**
 * Build the info segments that make up the footer.
 * Each segment is a themed string. We try to fit them all on one line;
 * when the line overflows we progressively drop low-priority segments.
 */
function buildSegments(
  ctx: ExtensionContext,
  footerData: ReadonlyFooterDataProvider,
  theme: { fg: (color: string, text: string) => string },
): string[] {
  const segments: string[] = [];

  // 1. PWD + branch
  let pwd = ctx.sessionManager.getCwd();
  const home =
    typeof process !== "undefined"
      ? process.env.HOME || process.env.USERPROFILE
      : undefined;
  if (home && pwd.startsWith(home)) pwd = `~${pwd.slice(home.length)}`;
  const branch = footerData.getGitBranch();
  const pwdStr = branch ? `${pwd} (${branch})` : pwd;
  segments.push(theme.fg("dim", pwdStr));

  // 2. Cost + context usage
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

  // 2. Cost + context usage
  const contextUsage = ctx.getContextUsage();
  const costParts: string[] = [];
  if (totalCost) {
    costParts.push(theme.fg("warning", `$${totalCost.toFixed(3)}`));
  }
  if (contextUsage) {
    const pctValue = contextUsage.percent ?? 0;
    const windowStr = formatTokens(contextUsage.contextWindow);
    let usedStr: string;
    if (contextUsage.percent !== null && contextUsage.contextWindow > 0) {
      const usedTokens = Math.round((pctValue / 100) * contextUsage.contextWindow);
      usedStr = formatTokens(usedTokens);
    } else {
      usedStr = "?";
    }

    let color: string;
    if (pctValue > 90) color = "error";
    else if (pctValue > 70) color = "warning";
    else color = "dim";

    costParts.push(theme.fg(color, `${usedStr}/${windowStr}`));
  }
  if (costParts.length > 0) {
    segments.push(costParts.join(" "));
  }

  // 4. Model
  const modelId = ctx.model?.name || ctx.model?.id || "no-model";
  segments.push(theme.fg("dim", modelId));

  // 5. Extension statuses (each becomes its own segment)
  const statuses = footerData.getExtensionStatuses();
  if (statuses.size > 0) {
    for (const [, text] of Array.from(statuses.entries()).sort(([a], [b]) =>
      a.localeCompare(b),
    )) {
      segments.push(sanitizeStatusText(text));
    }
  }

  return segments;
}

/**
 * Try to fit segments on one line. If they don't fit, progressively drop
 * from the front (lowest priority) until they do, and append "…" if truncated.
 */
function layoutSegments(segments: string[], width: number): string[] {
  const sepWidth = visibleWidth(SEPARATOR);

  // Compute cumulative widths
  const widths = segments.map((s) => visibleWidth(s));
  const totalSegmentWidth = widths.reduce((a, b) => a + b, 0);
  const totalWithSeps =
    totalSegmentWidth + Math.max(0, segments.length - 1) * sepWidth;

  if (totalWithSeps <= width) {
    // Everything fits on one line
    return [segments.join(SEPARATOR)];
  }

  // Progressive overflow: accumulate segments from the end (highest priority)
  // and see how many we can fit from the front
  const lines: string[] = [];
  let currentLine: string[] = [];
  let currentWidth = 0;

  // Iterate in reverse to prefer keeping later (higher-priority) segments
  // But we want natural reading order, so let's do forward with wrapping

  for (let i = 0; i < segments.length; i++) {
    const segWidth = widths[i]!;
    const needed =
      segWidth + (currentLine.length > 0 ? sepWidth : 0);

    if (currentWidth + needed <= width) {
      currentLine.push(segments[i]!);
      currentWidth += needed;
    } else {
      // Flush current line
      if (currentLine.length > 0) {
        lines.push(currentLine.join(SEPARATOR));
      }
      // Start new line with this segment; if segment alone exceeds width, truncate
      if (segWidth > width) {
        lines.push(truncateToWidth(segments[i]!, width, "…"));
        currentLine = [];
        currentWidth = 0;
      } else {
        currentLine = [segments[i]!];
        currentWidth = segWidth;
      }
    }
  }

  if (currentLine.length > 0) {
    lines.push(currentLine.join(SEPARATOR));
  }

  return lines;
}

export function installCompactFooter(
  _pi: unknown,
  ctx: ExtensionContext,
): () => void {
  let installed = true;

  ctx.ui.setFooter((tui, theme, footerData) => {
    const unsub = footerData.onBranchChange(() => tui.requestRender());

    return {
      dispose: () => {
        unsub();
        if (installed) {
          installed = false;
        }
      },
      invalidate() {
        // No cached state — we recompute every render from ctx + footerData
      },
      render(width: number): string[] {
        const segments = buildSegments(ctx, footerData, theme);
        const lines = layoutSegments(segments, width);
        // Truncate each line to width
        return lines.map((line) =>
          truncateToWidth(line, width, theme.fg("dim", "…")),
        );
      },
    };
  });

  // Return a cleanup function
  return () => {
    if (installed) {
      installed = false;
      ctx.ui.setFooter(undefined);
    }
  };
}
