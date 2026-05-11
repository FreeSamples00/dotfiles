import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";

const ALL_LEVELS: { value: string; label: string }[] = [
  { value: "off", label: "off — no thinking" },
  { value: "minimal", label: "minimal" },
  { value: "low", label: "low" },
  { value: "medium", label: "medium" },
  { value: "high", label: "high" },
  { value: "xhigh", label: "xhigh" },
];

export default function (pi: ExtensionAPI) {
  pi.registerCommand("thinking", {
    description: "Change thinking level",
    handler: async (args: string, ctx: ExtensionCommandContext) => {
      // If argument provided, use it directly
      const trimmed = args.trim();
      if (trimmed) {
        const valid = ALL_LEVELS.some((l) => l.value === trimmed);
        if (!valid) {
          ctx.ui.notify(`Unknown thinking level: "${trimmed}"`, "error");
          return;
        }
        pi.setThinkingLevel(trimmed as typeof ALL_LEVELS[number]["value"]);
        return;
      }

      // No argument — show picker
      const currentLevel = pi.getThinkingLevel();
      const thinkingLevelMap = ctx.model?.thinkingLevelMap;

      // Filter to levels supported by this model
      const available = ALL_LEVELS.filter((l) => {
        if (l.value === "off") return true;
        if (!ctx.model?.reasoning) return false;
        if (!thinkingLevelMap) return true; // no map = all supported
        return thinkingLevelMap[l.value] !== null;
      });

      const options = available.map((l) =>
        l.value === currentLevel ? `${l.label} ◆` : l.label,
      );

      const choice = await ctx.ui.select("Thinking level", options);
      if (choice === undefined) return;

      // Find the level by matching the label (stripping the ◆ marker)
      const selected = available.find((l) => {
        const marker = l.value === currentLevel ? `${l.label} ◆` : l.label;
        return marker === choice;
      });

      if (selected) {
        pi.setThinkingLevel(
          selected.value as typeof ALL_LEVELS[number]["value"],
        );
      }
    },
  });
}
