#!/usr/bin/env bash


sketchybar \
  "${ANIMATION[@]}" --set "mail.label" \
        label="--"

UNREAD=$(osascript -e 'tell application "Mail"
  set total to 0
  repeat with acc in accounts
    repeat with m in (mailboxes of acc)
      try
        if (name of m) contains "Inbox" or (name of m) contains "INBOX" then
          set total to total + (unread count of m)
        end if
      end try
    end repeat
  end repeat
  return total
end tell')

sketchybar \
  "${ANIMATION[@]}" --set "mail.label" \
        label="$UNREAD" \
