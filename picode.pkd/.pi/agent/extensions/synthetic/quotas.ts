export type QuotaSource = "header" | "api";

export interface QuotasResponse {
  subscription?: {
    limit: number;
    requests: number;
    renewsAt: string;
  };
  search?: {
    hourly?: {
      limit: number;
      requests: number;
      renewsAt: string;
    };
  };
  freeToolCalls?: {
    limit: number;
    requests: number;
    renewsAt: string;
  };
  weeklyTokenLimit?: {
    nextRegenAt: string;
    percentRemaining: number;
    maxCredits: string;
    remainingCredits: string;
    nextRegenCredits: string;
  };
  rollingFiveHourLimit?: {
    nextTickAt: string;
    tickPercent: number;
    remaining: number;
    max: number;
    limited: boolean;
  };
}

export interface QuotaSnapshot {
  quotas: QuotasResponse;
  source: QuotaSource;
  updatedAt: number;
}

const FETCH_TIMEOUT_MS = 15_000;

export function parseQuotaHeader(
  headers: Record<string, string>,
): QuotasResponse | undefined {
  const entry = Object.entries(headers).find(
    ([key]) => key.toLowerCase() === "x-synthetic-quotas",
  );
  if (!entry?.[1]) return undefined;
  try {
    const parsed = JSON.parse(entry[1]);
    if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed))
      return undefined;
    return parsed as QuotasResponse;
  } catch {
    return undefined;
  }
}

export async function fetchQuotas(
  apiKey: string,
  signal?: AbortSignal,
): Promise<QuotasResponse | undefined> {
  if (!apiKey) return undefined;

  const signals: AbortSignal[] = [AbortSignal.timeout(FETCH_TIMEOUT_MS)];
  if (signal) signals.push(signal);
  const combined = AbortSignal.any(signals);

  try {
    const response = await fetch("https://api.synthetic.new/v2/quotas", {
      headers: { Authorization: `Bearer ${apiKey}` },
      signal: combined,
    });
    if (!response.ok) return undefined;
    return (await response.json()) as QuotasResponse;
  } catch {
    return undefined;
  }
}

export function formatResetTime(renewsAt: string): string {
  const date = new Date(renewsAt);
  const now = new Date();
  const diffMs = date.getTime() - now.getTime();

  if (diffMs <= 0) return "soon";

  const diffHours = Math.ceil(diffMs / (1000 * 60 * 60));
  const diffDays = Math.ceil(diffMs / (1000 * 60 * 60 * 24));

  if (diffHours < 24) return `in ${diffHours}h`;
  if (diffDays < 7) return `in ${diffDays}d`;
  return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

export class QuotaStore {
  private snapshot: QuotaSnapshot | undefined;
  private lastHeaderIngestAt = 0;
  private inFlightRefresh:
    | Promise<QuotaSnapshot | undefined>
    | undefined;
  private inFlightId = 0;
  headerThrottleMs = 5_000;

  getSnapshot(): QuotaSnapshot | undefined {
    return this.snapshot;
  }

  ingest(quotas: QuotasResponse, source: QuotaSource): boolean {
    const now = Date.now();
    if (source === "header") {
      if (now - this.lastHeaderIngestAt < this.headerThrottleMs) return false;
      this.lastHeaderIngestAt = now;
    }
    this.snapshot = { quotas, source, updatedAt: now };
    return true;
  }

  async refreshFromApi(
    fetcher: () => Promise<QuotasResponse | undefined>,
  ): Promise<QuotaSnapshot | undefined> {
    if (this.inFlightRefresh) return this.inFlightRefresh;

    this.inFlightId++;
    const id = this.inFlightId;

    this.inFlightRefresh = (async () => {
      try {
        const quotas = await fetcher();
        if (quotas && id === this.inFlightId) {
          this.ingest(quotas, "api");
        }
        return this.snapshot;
      } finally {
        if (id === this.inFlightId) {
          this.inFlightRefresh = undefined;
        }
      }
    })();

    return this.inFlightRefresh;
  }

  clear(): void {
    this.inFlightId++;
    this.snapshot = undefined;
    this.lastHeaderIngestAt = 0;
    this.inFlightRefresh = undefined;
  }
}
