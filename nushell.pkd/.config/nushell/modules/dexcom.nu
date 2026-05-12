#!/usr/bin/env nu

# See https://github.com/gagebenne/pydexcom for complete reference

# ===== CONSTANTS =====

# location of stored session id
const SESSION_COOKIES = "~/.local/share/dexcom/session"

# API base url
const BASE_URL = "https://share2.dexcom.com/ShareWebServices/Services/"

# API endpoints
const ENDPOINTS = {
  login_id: General/LoginPublisherAccountById
  auth: General/AuthenticatePublisherAccount
  values: Publisher/ReadPublisherLatestGlucoseValues
}

# US application ID
const APP_ID = "d89443d2-327c-4a6f-89e5-496bbb0317db"
const DEFAULT_CRED = "proton"
const DEFAULT_UUID = "00000000-0000-0000-0000-000000000000"

const RETRY_CODES = [
  "SessionNotValid"
  "SessionIdNotFound"
]

# API error codes that indicate authentication failures
const AUTH_ERROR_CODES = [
  "AccountPasswordInvalid"
  "SSO_AuthenticateMaxAttemptsExceeded"
]

# ===== HELPERS =====

# handle stored session IDs
def cookie_load [] {
  let path = $SESSION_COOKIES | path expand
  if ($path | path exists) {
    open $path | str trim
  } else {
    create_new_session
  }
}

def cookie_save [] {
  mkdir ($SESSION_COOKIES | path expand | path dirname)
  $in | save -f $SESSION_COOKIES
}

# Get dexcom credentials
def get_creds [
  source: string@["user" "proton"] = $DEFAULT_CRED # where to source credential from
]: nothing -> record<username: string, password: string> {
  return (match $source {
    "user" => {
      username: (input "Username: ")
      password: (input "Password: ")
    }
    "proton" => {
      let creds = pass-cli item view --item-title Dexcom --output json | from json
      return {
        username: $creds.item.content.content.Login.username
        password: $creds.item.content.content.Login.password
      }
    }
    _ => {
      make err { msg: $"Invalid credential source '($source)'"}
    }
  })
}

# Retrieve user's account ID
def get_account_id [creds: record<username: string, password: string>]: nothing -> string {
  post $ENDPOINTS.auth {accountName: $creds.username, password: $creds.password, applicationId: $APP_ID}
}

# create a new session id
def create_new_session []: nothing -> string {
  let creds = get_creds
  let session_id = post $ENDPOINTS.login_id {
    accountId: (get_account_id $creds)
    password: $creds.password
    applicationId: $APP_ID
  }
  if ($session_id | describe) != "string" or $session_id == $DEFAULT_UUID {
    error make {msg: "Error creating new session"}
  } else {
    $session_id | cookie_save
    return $session_id
  }
}

# send post request to dexcom API
def post [endpoint: string, body: record] {
  let resp = http post $"($BASE_URL)($endpoint)" --content-type application/json --allow-errors --headers {
      Accept-Encoding: application/json
    } $body

  if (is-api-error $resp) {
    error make {msg: $"Dexcom ($resp.Code): ($resp.Message)"}
  }
  $resp
}

# Parse dexcom display time (DT) timestamp
def parse_timestamp []: string -> datetime {
  let m = $in | parse --regex `Date\((?<ts>\d+)(?<offset>[+-]\d{4})\)`
  let ts = $m.ts.0 | into int
  let offset_str = $m.offset.0

  # get offset
  let offset_sign = if ($offset_str | str starts-with "+") { 1 } else { -1 }
  let offset_hours = ($offset_str | str substring 1..=2 | into int) * $offset_sign

  # ms → seconds
  let epoch_secs = $ts / 1000 | into int

  # epoch → timezone
  $epoch_secs | into datetime -f "%s" --offset $offset_hours
}

# Check if a value is a Dexcom API error record
# The API returns {Code: ..., Message: ...} on errors; success returns a list or string
def is-api-error [val]: nothing -> bool {
  ($val | describe | str starts-with "record") and ($val.Code? | describe | str starts-with "string")
}

def get_bg_raw [
  minutes: int = 5 # n minutes to request
  count: int = 1 # maximum entries to retrieve
] {
  let resp = http post $"($BASE_URL)($ENDPOINTS.values)" --content-type application/json --allow-errors --headers {
      Accept-Encoding: application/json
    } {
    sessionID: (cookie_load)
    minutes: $minutes
    maxCount: $count
  }

  # Session expired — refresh and retry once
  if (is-api-error $resp) and ($resp.Code in $RETRY_CODES) {
    create_new_session
    post $ENDPOINTS.values {
      sessionID: (cookie_load)
      minutes: $minutes
      maxCount: $count
    }
  } else if (is-api-error $resp) {
    error make {msg: $"Dexcom ($resp.Code): ($resp.Message)"}
  } else {
    $resp
  }
}

# ===== EXPORTED =====

# get bg value from dexcom
export def main [
  --minutes(-m): int = 5, # time period to query
  --count(-c): int = 1, # max values to return
  --raw(-r) # return all values
] {
  let readings = get_bg_raw $minutes $count

  if $raw {
    $readings
  } else {
    $readings
    | insert Arrow {
      match $in.Trend {
          "None" => ""
          "DoubleUp" => "↑↑"
          "SingleUp" => "↑"
          "FortyFiveUp" => "↗"
          "Flat" => "→"
          "FortyFiveDown" => "↘"
          "SingleDown" => "↓"
          "DoubleDown" => "↓↓"
          "NotComputable" => "?"
          "RateOutOfRange" => "-"
          _ => $in
      }
    }
    | insert Time {
      $in.DT | parse_timestamp
    }
    | select Time Value Arrow
  }
}
