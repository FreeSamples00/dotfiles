#!/usr/bin/env bash

set -euo pipefail

# Cache for networksetup mapping (seconds)
CACHE_DIR=${XDG_RUNTIME_DIR:-/tmp}
MAP_TTL="${NET_HW_MAP_TTL:-3}"
MAP_CACHE="$CACHE_DIR/net_hw_map_$(id -u)"

# 1) get default route (gateway + interface) in one fast call
route_out=$(route get default 2>/dev/null || true)
if [ -z "${route_out:-}" ]; then
  echo "offline"
  exit 0
fi
read -r gw iface < <(printf '%s' "$route_out" | awk '
  /gateway:/{g=$2}
  /interface:/{i=$2}
  END{print g, i}
')

# 2) device -> Hardware Port mapping (cached to avoid repeated networksetup calls)
if [ ! -f "$MAP_CACHE" ] || \
   [ $(( $(date +%s) - $(stat -f %m "$MAP_CACHE") )) -ge "$MAP_TTL" ]; then
  networksetup -listallhardwareports 2>/dev/null | awk '
    /^Hardware Port: /{hp=substr($0,16)}
    /^Device: /{dev=substr($0,9); print dev "\t" hp}
  ' > "${MAP_CACHE}.tmp" && mv "${MAP_CACHE}.tmp" "$MAP_CACHE"
fi
hw=$(awk -F'\t' -v dev="$iface" '$1==dev{print $2; exit}' "$MAP_CACHE" || true)
hw=${hw:-Unknown}

# 3) classification
case "$hw" in
  *iPhone*|*iPad*|*iPhone\ USB*)
    echo "hotspot"
    exit 0
    ;;
  *Bluetooth*|*PAN*)
    echo "hotspot"
    exit 0
    ;;
  *Ethernet*|*Thunderbolt*|*USB\ Ethernet*|*USB\ 10/100/1000*)
    echo "ethernet"
    exit 0
    ;;
  *Wi-Fi*|*AirPort*)
    # fast SSID read via private airport utility (fallback to networksetup)
    airport=/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport
    if [ -x "$airport" ]; then
      ssid=$("$airport" -I 2>/dev/null \
             | awk -F' SSID: ' '/ SSID: /{print $2; exit}')
    else
      ssid=$(networksetup -getairportnetwork "$iface" 2>/dev/null \
             | sed -E 's/^Current Wi-?Fi Network: //')
    fi

    # Heuristics for Personal Hotspot
    if [ -n "${gw:-}" ] && printf '%s\n' "$gw" | grep -qE '^172\.20\.'; then
      echo "hotspot"
      exit 0
    fi
    if [ -n "${ssid:-}" ] && printf '%s\n' "$ssid" | grep -qiE 'iphone|ipad|hotspot'; then
      echo "hotspot"
      exit 0
    fi

    echo "wifi"
    exit 0
    ;;
  *)
    # unknown hardware port -> output what we found for debugging
    echo "$hw (device: $iface)"
    exit 0
    ;;
esac
