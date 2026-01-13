import type { Plugin } from "@opencode-ai/plugin"

interface AuthJson {
  synthetic?: {
    key: string
  }
}

interface SubscriptionData {
  requests: number
  limit: number
  renewsAt: string
}

interface UsageResponse {
  subscription: SubscriptionData
}

export const SyntheticUsagePlugin: Plugin = async ({ client, $ }) => {

  const getApiKey = async (): Promise<string> => {
    try {
      const authPath = `${process.env.HOME}/.local/share/opencode/auth.json`
      const result = await $`cat ${authPath}`.json() as unknown as AuthJson
      return result.synthetic?.key || ""
    } catch {
      return ""
    }
  }

  const calculatePercentUsed = (used: number, limit: number): number => {
    if (limit === 0) return 0
    return Math.round((used / limit) * 100)
  }

  const formatTimeToReset = (isoDate: string): string => {
    const renewDate = new Date(isoDate)
    const now = new Date()
    const diffMs = renewDate.getTime() - now.getTime()

    if (diffMs <= 0) return "Expired"

    const diffMins = Math.floor(diffMs / (1000 * 60))

    if (diffMins < 1) return "< 1m"

    const hours = Math.floor(diffMins / 60)
    const minutes = diffMins % 60

    if (hours > 0) {
      return `${hours}h ${minutes}m`
    }
    return `${minutes}m`
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const apiKey = await getApiKey()

        if (!apiKey) {
          await client.tui.showToast({
            body: {
              message: "Synthetic key not found",
              variant: "error"
            }
          })
          return
        }

        try {
          const response = await $`curl -s https://api.synthetic.new/v2/quotas -H "Authorization: Bearer ${apiKey}"`.json() as unknown as UsageResponse
          const { subscription } = response

          const percentUsed = calculatePercentUsed(subscription.requests, subscription.limit)
          const timeToReset = formatTimeToReset(subscription.renewsAt)

          const variant = percentUsed > 80 ? "error" : percentUsed > 60 ? "warning" : "success"

          await client.tui.showToast({
            body: {
              message: `Synthetic: ${subscription.requests}/${subscription.limit} req (${percentUsed}%) • Resets: ${timeToReset}`,
              variant
            }
          })
        } catch (error) {
          await client.tui.showToast({
            body: {
              message: "Failed to fetch Synthetic usage",
              variant: "error"
            }
          })
        }
      }
    }
  }
}
