#!/usr/bin/env bash

get_aerospace_workspaces() {
  aerospace list-workspaces --all
}

get_aerospace_focused_workspace() {
  aerospace list-workspaces --focused
}

get_aerospace_workspace_status() {
  local ws_id=$1
  local windows
  windows=$(aerospace list-windows --workspace "$ws_id" 2>/dev/null)

  if [ -z "$windows" ]; then
    echo "empty"
  else
    echo "active"
  fi
}

get_aerospace_workspace_apps() {
  local ws_id=$1
  aerospace list-windows --workspace "$ws_id" 2>/dev/null | jq -r '.[].app' | sort -u | grep -v '^$'
}

get_aerospace_workspace_click_command() {
  local ws_id=$1
  echo "aerospace workspace $ws_id"
}
