#!/usr/bin/env nu

# See https://github.com/gagebenne/pydexcom for complete reference

# ===== CONSTANTS =====

# storage cache
const CACHE_DIR = $"~/.local/share/dexcom"
const SESSION_FILE = $"($CACHE_DIR)/session"
const LOG_FILE = $"($CACHE_DIR)/logs.jsonl"

# API base url
const BASE_URL = "https://share2.dexcom.com/ShareWebServices/Services/"

# API endpoints
const ENDPOINTS = {
  login_id: General/LoginPublisherAccountById
  auth: General/AuthenticatePublisherAccount
  bg_values: Publisher/ReadPublisherLatestGlucoseValues
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

def log [
  level: string # log level
  cause: string # what triggered the log event
  data?: record # extra context
] {
  {
    ts: (date now | into string)
    level: $level
    cause: $cause
    data: ($data | to json --raw)
  }
  | to json --raw
  | str trim
  | $"($in)\n"
  | save --append $LOG_FILE
}

# handle stored session IDs
def cookie_load [] {
  let path = $SESSION_FILE | path expand
  if ($path | path exists) {
    open $path | str trim
  } else {
    create_new_session
  }
}

def cookie_save [] {
  mkdir ($SESSION_FILE | path expand | path dirname)
  $in | save -f $SESSION_FILE
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
      let creds = try {
        pass-cli item view --item-title Dexcom --output json | from json
      } catch { |err|
        log "error" "creds" {source: "proton", event: "retrieval failure", error: $err.msg}
        error make {msg: $"Failed to retrieve Dexcom credentials from proton: ($err.msg)"}
      }
      try {
        return {
          username: $creds.item.content.content.Login.username
          password: $creds.item.content.content.Login.password
        }
      } catch { |err|
        log "error" "creds" {source: "proton", event: "parse failure", error: $err.msg}
        error make {msg: $"Dexcom credential structure unexpected: ($err.msg)"}
      }
    }
    _ => {
      make err { msg: $"Invalid credential source '($source)'"}
    }
  })
}

# Retrieve user's account ID
def get_account_id [creds: record<username: string, password: string>]: nothing -> string {
  post! "auth" {accountName: $creds.username, password: $creds.password, applicationId: $APP_ID}
}

# create a new session id
def create_new_session []: nothing -> string {
  let creds = get_creds
  let session_id = post! "login_id" {
    accountId: (get_account_id $creds)
    password: $creds.password
    applicationId: $APP_ID
  }
  if ($session_id | describe) != "string" or $session_id == $DEFAULT_UUID {
    log "error" "session" {event: "creation failure"}
    error make {msg: "Error creating new session"}
  } else {
    log "info" "session" {event: "created"}
    $session_id | cookie_save
    return $session_id
  }
}

# Send post request to dexcom API (raw — returns response as-is)
def post [endpoint: string@[login_id auth bg_values], body: record] {
  let path = $ENDPOINTS | get $endpoint
  http post $"($BASE_URL)($path)" --content-type application/json --allow-errors --headers {
      Accept-Encoding: application/json
    } $body
}

# Send post request to dexcom API (raises on error, logs result)
def post! [endpoint: string, body: record] {
  let resp = post $endpoint $body

  if (is-api-error $resp) {
    (log
      "error"
      "api"
      {endpoint: $endpoint, code: $resp.Code, message: $resp.Message}
    )
    error make {msg: $"Dexcom ($resp.Code): ($resp.Message)"}
  }
  log "info" "api" {endpoint: $endpoint, status: "success"}
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
  let resp = post "bg_values" {
    sessionID: (cookie_load)
    minutes: $minutes
    maxCount: $count
  }

  # Session expired — refresh and retry once
  if (is-api-error $resp) and ($resp.Code in $RETRY_CODES) {
    log "warn" "session" {event: "expired", code: $resp.Code}
    create_new_session
    post! "bg_values" {
      sessionID: (cookie_load)
      minutes: $minutes
      maxCount: $count
    }
  } else if (is-api-error $resp) {
    (log
      "error"
      "api"
      {endpoint: "bg_values", code: $resp.Code, message: $resp.Message}
    )
    error make {msg: $"Dexcom ($resp.Code): ($resp.Message)"}
  } else {
    log "info" "api" {endpoint: "bg_values", status: "success"}
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

export def logs [
  --path (-p) # return logs location
  --raw (-r) # get raw log data
  --clear # clear logs
] {
  if $path {
    return ($LOG_FILE | path expand)
  } else if $clear {
    "" | save --force ($LOG_FILE | path expand)
  } else {
    open ($LOG_FILE | path expand)
    | from json --objects
    | update data {|| $in | from json}
    | if $raw {
      return $in
    } else {
      $in
      | update ts {|| $in | into datetime}
    }
  }
}
