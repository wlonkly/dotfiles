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
else
  sketchybar --set "space.${WORKSPACE}" \
    background.border_color=0x00000000
fi
