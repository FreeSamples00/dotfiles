import type { ProviderModelConfig } from "@earendil-works/pi-coding-agent";

export const SYNTHETIC_MODELS: ProviderModelConfig[] = [
  {
    id: "hf:zai-org/GLM-5.1",
    name: "zai-org/GLM-5.1",
    reasoning: true,
    thinkingLevelMap: { minimal: null, xhigh: null },
    compat: {
      supportsReasoningEffort: true,
      supportsDeveloperRole: false,
      maxTokensField: "max_tokens",
    },
    input: ["text"],
    cost: {
      input: 1,
      output: 3,
      cacheRead: 1,
      cacheWrite: 0,
    },
    contextWindow: 196608,
    maxTokens: 65536,
  },
  {
    id: "hf:openai/gpt-oss-120b",
    name: "openai/gpt-oss-120b",
    reasoning: true,
    input: ["text"],
    cost: {
      input: 0.1,
      output: 0.1,
      cacheRead: 0.1,
      cacheWrite: 0,
    },
    contextWindow: 131072,
    maxTokens: 32768,
    compat: {
      supportsDeveloperRole: false,
      maxTokensField: "max_tokens",
    },
  },
];
