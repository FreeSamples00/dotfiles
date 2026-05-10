import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import {
  type QuotasResponse,
  type QuotaSnapshot,
  formatResetTime,
} from "./quotas";

export type RiskSeverity = "none" | "warning" | "high" | "critical";

interface QuotaWindow {
  label: string;
  usedPercent: number;
  resetsAt: Date;
  windowSeconds: number;
  usedValue: number;
  limitValue: number;
  isCurrency?: boolean;
  showPace?: boolean;
  paceScale?: number;
  limited?: boolean;
}

const MIN_PACE_PERCENT = 5;

const THRESHOLDS = {
  usedFloor: { start: 33, end: 8 },
  warnProjected: { start: 260, end: 120 },
  highProjected: { start: 320, end: 145 },
  criticalProjected: { start: 400, end: 170 },
};

function interpolate(start: number, end: number, progress: number): number {
  return start + (end - start) * Math.max(0, Math.min(1, progress));
}

function safePercent(used: number, limit: number): number {
  if (!Number.isFinite(used) || !Number.isFinite(limit) || limit <= 0) return 0;
  return Math.max(0, Math.min(100, (used / limit) * 100));
}

function parseCurrency(value: string): number {
  const n = Number(value.replace(/[^0-9.-]/g, ""));
  return Number.isFinite(n) ? n : 0;
}

function getPacePercent(window: QuotaWindow): number | null {
  const totalMs = window.windowSeconds * 1000;
  if (totalMs <= 0) return null;
  const remainingMs = window.resetsAt.getTime() - Date.now();
  const elapsedMs = totalMs - remainingMs;
  return Math.max(0, Math.min(100, (elapsedMs / totalMs) * 100));
}

function getProjectedPercent(
  usedPercent: number,
  pacePercent: number | null,
): number {
  if (pacePercent === null) return usedPercent;
  const effectivePace = Math.max(MIN_PACE_PERCENT, pacePercent);
  return Math.max(0, (usedPercent / effectivePace) * 100);
}

function assessWindow(window: QuotaWindow): RiskSeverity {
  const rawPace = window.showPace ? getPacePercent(window) : null;
  const pacePercent =
    rawPace !== null ? rawPace * (window.paceScale ?? 1) : null;
  const projectedPercent = getProjectedPercent(window.usedPercent, pacePercent);
  const progress = pacePercent !== null ? pacePercent / 100 : null;

  if (window.limited) return "critical";
  if (progress === null) {
    if (projectedPercent >= 100) return "critical";
    if (projectedPercent >= 90) return "high";
    if (projectedPercent >= 80) return "warning";
    return "none";
  }

  const usedFloorPercent = interpolate(
    THRESHOLDS.usedFloor.start,
    THRESHOLDS.usedFloor.end,
    progress,
  );
  const criticalProjectedPercent = interpolate(
    THRESHOLDS.criticalProjected.start,
    THRESHOLDS.criticalProjected.end,
    progress,
  );
  const highProjectedPercent = interpolate(
    THRESHOLDS.highProjected.start,
    THRESHOLDS.highProjected.end,
    progress,
  );
  const warnProjectedPercent = interpolate(
    THRESHOLDS.warnProjected.start,
    THRESHOLDS.warnProjected.end,
    progress,
  );

  if (window.usedPercent >= usedFloorPercent) {
    if (projectedPercent >= criticalProjectedPercent) return "critical";
    if (projectedPercent >= highProjectedPercent) return "high";
    if (projectedPercent >= warnProjectedPercent) return "warning";
  }

  return "none";
}

export function getSeverityColor(
  severity: RiskSeverity,
): "success" | "warning" | "error" {
  switch (severity) {
    case "critical":
    case "high":
      return "error";
    case "warning":
      return "warning";
    default:
      return "success";
  }
}

function toWindows(quotas: QuotasResponse): QuotaWindow[] {
  const windows: QuotaWindow[] = [];

  if (quotas.weeklyTokenLimit) {
    const { weeklyTokenLimit } = quotas;
    const limitValue = parseCurrency(weeklyTokenLimit.maxCredits);
    const remainingValue = parseCurrency(weeklyTokenLimit.remainingCredits);
    windows.push({
      label: "Credits / week",
      usedPercent: Math.max(
        0,
        Math.min(100, 100 - weeklyTokenLimit.percentRemaining),
      ),
      resetsAt: new Date(weeklyTokenLimit.nextRegenAt),
      windowSeconds: 24 * 60 * 60,
      usedValue: limitValue - remainingValue,
      limitValue,
      isCurrency: true,
      showPace: true,
      paceScale: 1 / 7,
    });
  }

  if (quotas.rollingFiveHourLimit && quotas.rollingFiveHourLimit.max > 0) {
    const { rollingFiveHourLimit } = quotas;
    const used = rollingFiveHourLimit.max - rollingFiveHourLimit.remaining;
    windows.push({
      label: "Requests / 5h",
      usedPercent: safePercent(used, rollingFiveHourLimit.max),
      resetsAt: new Date(rollingFiveHourLimit.nextTickAt),
      windowSeconds: 5 * 60 * 60,
      usedValue: Math.round(used),
      limitValue: rollingFiveHourLimit.max,
      showPace: false,
      limited: rollingFiveHourLimit.limited,
    });
  }

  if (
    !quotas.rollingFiveHourLimit &&
    quotas.subscription?.limit &&
    quotas.subscription.limit > 0
  ) {
    const pct =
      (quotas.subscription.requests / quotas.subscription.limit) * 100;
    windows.push({
      label: "Requests / 5h",
      usedPercent: Math.round(Math.max(0, Math.min(100, pct))),
      resetsAt: new Date(quotas.subscription.renewsAt),
      windowSeconds: 5 * 60 * 60,
      usedValue: quotas.subscription.requests,
      limitValue: quotas.subscription.limit,
      showPace: false,
    });
  }

  if (quotas.search?.hourly?.limit && quotas.search.hourly.limit > 0) {
    const { hourly } = quotas.search;
    windows.push({
      label: "Search / hour",
      usedPercent: safePercent(hourly.requests, hourly.limit),
      resetsAt: new Date(hourly.renewsAt),
      windowSeconds: 60 * 60,
      usedValue: hourly.requests,
      limitValue: hourly.limit,
      showPace: true,
      paceScale: 1,
    });
  }

  if (quotas.freeToolCalls?.limit && quotas.freeToolCalls.limit > 0) {
    windows.push({
      label: "Free Tool Calls / day",
      usedPercent: safePercent(
        quotas.freeToolCalls.requests,
        quotas.freeToolCalls.limit,
      ),
      resetsAt: new Date(quotas.freeToolCalls.renewsAt),
      windowSeconds: 24 * 60 * 60,
      usedValue: quotas.freeToolCalls.requests,
      limitValue: quotas.freeToolCalls.limit,
      showPace: true,
      paceScale: 1,
    });
  }

  return windows;
}

const SHORT_LABELS: Record<string, string> = {
  "Credits / week": "week",
  "Requests / 5h": "5h",
  "Search / hour": "search",
  "Free Tool Calls / day": "tools",
};

interface WindowStatus {
  label: string;
  usedPercent: number;
  severity: RiskSeverity;
  resetsAt: string | null;
  limited: boolean;
}

function parseSnapshot(quotas: QuotasResponse): WindowStatus[] {
  return toWindows(quotas).map((w) => ({
    label: w.label,
    usedPercent: w.usedPercent,
    severity: assessWindow(w),
    resetsAt: w.resetsAt.toISOString(),
    limited: w.limited ?? false,
  }));
}

const BAR_WIDTH = 5;
const BAR_FILLED = "▓";
const BAR_EMPTY = "░";

function formatBar(remainingPercent: number, width: number): string {
  const filled = Math.round((remainingPercent / 100) * width);
  return BAR_FILLED.repeat(filled) + BAR_EMPTY.repeat(width - filled);
}

export function formatStatus(
  ctx: ExtensionContext,
  snapshot: QuotaSnapshot | undefined,
): string | undefined {
  if (!ctx.hasUI) return undefined;
  if (!snapshot) return ctx.ui.theme.fg("dim", "loading usage...");

  const windows = parseSnapshot(snapshot.quotas);
  if (windows.length === 0) return undefined;

  const theme = ctx.ui.theme;
  const parts: string[] = [];

  for (const w of windows) {
    const short = SHORT_LABELS[w.label] ?? w.label;
    const remaining = Math.max(
      0,
      Math.min(100, 100 - Math.round(w.usedPercent)),
    );
    const color = getSeverityColor(w.severity);
    const bar = theme.fg(color, formatBar(remaining, BAR_WIDTH));
    const pctText = theme.fg(color, `${remaining}%`);
    const reset = w.resetsAt
      ? theme.fg("dim", `\u21ba${formatResetTime(w.resetsAt)}`)
      : "";
    const limitTag = w.limited ? theme.fg("error", " [limited]") : "";
    parts.push(
      `${theme.fg("dim", `${short} `)}${bar} ${pctText} ${reset}${limitTag}`,
    );
  }

  return parts.join(theme.fg("dim", " │ "));
}
