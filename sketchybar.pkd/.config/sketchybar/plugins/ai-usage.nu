#!/usr/bin/env nu -n

const url_base = "https://api.synthetic.new"
const usage_route = "/v2/quotas"

# Gets API key from opencode storage location
def api_key [] {
  open ~/.local/share/opencode/auth.json | get synthetic.key
}

# Get subscription usage and quota information
def get-usage [
  mode: string@["percentage" "ratio" "time-remaining" "time-standard"]
] {
  http get --headers {Authorization: $"Bearer (api_key)"} $"($url_base)($usage_route)"
  | match $mode {
    "percentage" => {$"($in.subscription | ($in.requests / $in.limit) | math round -p 1 | into string)%"}
    "ratio" => {$"($in.subscription.requests)/($in.subscription.limit)"}
    "time-remaining" => {$in.subscription | get renewsAt | date humanize}
    "time-standard" => {$in.subscription | get renewsAt | format date "%I:%M"}
  }
}

def main [
  name: string
  animation_type: string
  animation_speed: string
] {
  sketchybar ...[
    --animate $animation_type $animation_speed
    --set $name
    label=--
  ]
  sketchybar ...[
    --animate $animation_type $animation_speed
    --set $name
    label=(get-usage percentage)
  ]
}
