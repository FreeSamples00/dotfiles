#!/usr/bin/env nu -n

const url_base = "https://api.synthetic.new"
const usage_route = "/v2/quotas"

# Gets API key from opencode storage location
def api_key [] {
  open ~/.local/share/opencode/auth.json | get synthetic.key
}

def get-usage [] {
  let resp = http get --headers {Authorization: $"Bearer (api_key)"} $"($url_base)($usage_route)"
  let five_hr = $resp.rollingFiveHourLimit
    | ($in.remaining / $in.max * 100)
    | math round -p 0
    | into string
    | $in + "%"
  let weekly = $resp.weeklyTokenLimit.percentRemaining
    | math round -p 1
    | into string
    | $in + "%"
  $"($five_hr)·($weekly)"
}

def main [name: string, animation_type: string, animation_speed: string] {
  sketchybar ...[
    --animate
    $animation_type
    $animation_speed
    --set
    $name
    label=--
  ]
  sketchybar ...[
    --animate
    $animation_type
    $animation_speed
    --set
    $name
    label=(get-usage)
  ]
}
