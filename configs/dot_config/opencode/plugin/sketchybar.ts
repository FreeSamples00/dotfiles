import type { Plugin } from "@opencode-ai/plugin"
export const SketchbarPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        try {
          await $`sketchybar --trigger opencode-completion`
        } catch (error) {
          // Silently fail to avoid noise - sketchybar might not be running
        }
      }
    }
  }
}
