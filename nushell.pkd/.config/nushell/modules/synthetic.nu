# Synthetic.new API Client Module

const url_base = "https://api.synthetic.new"
const usage_route = "/v2/quotas"
const models_route = "/openai/v1/models"
const tokens_route = "/anthropic/v1/messages/count_tokens"


# Gets API key from opencode storage location
def api_key [] {
  open ~/.local/share/opencode/auth.json | get synthetic.key
}

# Get subscription usage and quota information
export def usage [
  --raw (-r) # Return unmodified API response
] {
  http get --headers {Authorization: $"Bearer (api_key)"} $"($url_base)($usage_route)"
  | if $raw {$in} else {
    get subscription
    | insert reset_relative {|| $in.renewsAt | date humanize}
    | insert reset_absolute {|| $in.renewsAt | date to-timezone US/Central }
    | insert reset_timezone US/Central
    | reject renewsAt
  }
}

# List available models
export def models [] {
  http get --headers {Authorization: $"Bearer (api_key)"} $"($url_base)($models_route)"
  | get data
}

# Count tokens for a message (subscriber feature)
export def tokens [
  iotype: string@[input output] # Token type
  model: string@[glm qwen deepseek llama] # Model to evaluate with
  content: string # Text to analyze
] {
  let role = match $iotype {
    input => "user"
    output => "assistant"
    _ => (error make {
        msg: $"io-type `($iotype)` not supported."
        help: $"Use one of: [input output]."
        label: {
          text: "unknown type"
          span: (metadata $iotype | get span)
        }
      }
    )
  }
  let model = match $model {
    glm => "hf:zai-org/GLM-4.7"
    qwen => "hf:Qwen/Qwen3-235B-A22B-Instruct-2507"
    deepseek => "hf:deepseek-ai/DeepSeek-V3.2"
    llama => "hf:meta-llama/Llama-3.3-70B-Instruct"
    _ => (error make {
        msg: $"model `($model)` not supported."
        help: $"Use one of: [glm qwen deepseek llama]."
        label: {
          text: "unknown model"
          span: (metadata $model | get span)
        }
      }
    )
  }
  let body = {
    model: $model,
    messages: [{role: $role, content: $content}]
  } | to json
  http post --headers {Authorization: $"Bearer (api_key)"} $"($url_base)($tokens_route)" $body
}
