#!/usr/bin/env nu -n

def main [] {
  use ../core/icons.nu *

  let restart_enable = $env.restart_enable | into bool
  let focus_enable = $env.focus_enable | into bool

  if $restart_enable {
    let restart_script = [
      ($env.CONFIG_DIR)/plugins/restart_notifier.nu
      "notifiers_restart"
      $env.animation_type
      $env.animation_speed
      $env.restart_threshold
    ] | str join " "

    sketchybar ...[
      --add
      item
      notifiers_restart
      $env.side
      --set
      notifiers_restart
      icon=(icons widget restart)
      icon.color=($env.restart_color)
      label.padding_right=0
      label.padding_left=0
      script=($restart_script)
      click_script=`osascript -e 'tell application "loginwindow" to «event aevtrrst»'`
      update_freq=($env.restart_update_freq)
      updates=on
      --subscribe
      notifiers_restart
      system_woke
    ]
  }

  if $focus_enable {
    let focus_script = [
      ($env.CONFIG_DIR)/plugins/focus_notifier.nu
      "notifiers_focus"
      $env.animation_type
      $env.animation_speed
    ] | str join " "

    sketchybar ...[
      --add
      item
      notifiers_focus
      $env.side
      --set
      notifiers_focus
      label.padding_right=0
      label.padding_left=0
      script=($focus_script)
      click_script=($focus_script)
      update_freq=($env.focus_update_freq)
      updates=on
      --subscribe
      notifiers_focus
      system_woke
    ]
  }
}
