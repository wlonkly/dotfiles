#!/usr/bin/env bash

# Called with: aerospace.sh <workspace_id>
# ENV: FOCUSED_WORKSPACE (from aerospace_workspace_change event)

WORKSPACE="$1"

source "$HOME/.config/sketchybar/colors.sh"

if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "space.${WORKSPACE}" \
    background.border_color="$WHITE"
  # Rebuild app icons once using a lock file
  LOCKFILE="/tmp/sketchybar_app_manager.lock"
  if [ ! -f "$LOCKFILE" ]; then
    touch "$LOCKFILE"
    "$CONFIG_DIR/plugins/app_manager.sh"
    rm -f "$LOCKFILE"
  fi
else
  sketchybar --set "space.${WORKSPACE}" \
    background.border_color=0x00000000
fi
