#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

PLUGIN="$CONFIG_DIR/plugins/aerospace.sh"
APP_ICON_PLUGIN="$CONFIG_DIR/plugins/app_icon.sh"
APP_MANAGER_PLUGIN="$CONFIG_DIR/plugins/app_manager.sh"
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

# Create workspace items
for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item "space.${sid}" left \
    --set "space.${sid}" \
      icon="$sid" \
      icon.font="SF Mono:Bold:14.0" \
      icon.color=$WHITE \
      icon.padding_left=10 \
      icon.padding_right=10 \
      label.drawing=off \
      background.color=0x33ffffff \
      background.corner_radius=5 \
      background.height=25 \
      background.border_width=2 \
      background.border_color=0x00000000 \
      background.drawing=on \
      padding_left=4 \
      padding_right=4 \
      click_script="aerospace workspace $sid" \
      script="$PLUGIN $sid" \
    --subscribe "space.${sid}" aerospace_workspace_change
done

# Initial setup - create all app items
$APP_MANAGER_PLUGIN

# Initial state for workspace focus indicators
for sid in $(aerospace list-workspaces --all); do
  FOCUSED_WORKSPACE="$FOCUSED" "$PLUGIN" "$sid"
done
