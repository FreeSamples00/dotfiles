# AI model definitions for opencode
# These variables are injected into the generated opencode.jsonc

{
  # Model IDs (provider/model format)
  models = {
    large  = "synthetic/syn:large:text";
    small  = "synthetic/syn:small:text";
    vision = "synthetic/syn:large:vision";
  };

  # Provider configuration
  provider = {
    npm = "@ai-sdk/openai-compatible";
    name = "synthetic";
    baseURL = "https://api.synthetic.new/openai/v1";
  };

  # Model specs (limits, cost, family, etc.)
  specs = {
    "syn:large:text" = {
      name = "Max";
      limit = { context = 524288; output = 65536; };
      cost = { input = 1.4; output = 4.4; };
      family = "GLM";
      reasoning = true;
    };
    "syn:small:text" = {
      name = "Lite";
      limit = { context = 196608; output = 65536; };
      cost = { input = 0.1; output = 0.5; };
      family = "GLM";
      reasoning = true;
    };
    "syn:large:vision" = {
      name = "Vision";
      modalities = {
        input = [ "text" "image" ];
        output = [ "text" ];
      };
      limit = { context = 262144; output = 65536; };
      cost = { input = 0.95; output = 4.0; };
      family = "Kimi";
      reasoning = true;
    };
  };

  # Per-agent model + reasoning effort assignments
  agents = {
    plan        = { model = "large";  reasoningEffort = "low"; };
    build       = { model = "large";  reasoningEffort = "low"; };
    explorer    = { model = "small";  reasoningEffort = "low"; };
    librarian   = { model = "small";  reasoningEffort = "medium"; };
    documenter  = { model = "small";  reasoningEffort = "medium"; };
    fixer       = { model = "large";  reasoningEffort = "low"; };
    compaction  = { model = "large";  reasoningEffort = "low"; };
    vision      = { model = "vision"; reasoningEffort = "low"; };
    oracle      = { model = "large";  reasoningEffort = "high"; };
  };
}
