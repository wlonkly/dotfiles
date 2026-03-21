#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

PLUGIN="$CONFIG_DIR/plugins/aerospace.sh"
APP_ICON_PLUGIN="$CONFIG_DIR/plugins/app_icon.sh"
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

# Create workspace items and their app icons together (to maintain order)
for sid in $(aerospace list-workspaces --all); do
  # Get unique bundle_ids for this workspace
  bundle_ids=$(aerospace list-windows --workspace "$sid" --format '%{app-bundle-id}' | sort -u)

  # Create workspace number item
  sketchybar --add item "space.${sid}" left \
    --set "space.${sid}" \
      icon="$sid" \
      icon.font="SF Mono:Bold:14.0" \
      icon.color="$WHITE" \
      icon.padding_left=10 \
      icon.padding_right=10 \
      icon.padding_bottom=4 \
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

  # Create app icon items for this workspace (immediately after the workspace item)
  app_num=0
  for bundle_id in $bundle_ids; do
    sketchybar --add item "space.${sid}.app.${app_num}" left \
      --set "space.${sid}.app.${app_num}" \
        icon.font="sketchybar-app-font:Regular:14.0" \
        icon.color=$ICON_COLOR \
        icon.padding_left=4 \
        icon.padding_right=4 \
        icon.padding_top=2 \
        icon.padding_bottom=2 \
        label.drawing=off \
        background.drawing=off \
        padding_left=0 \
        padding_right=0 \
        script="$APP_ICON_PLUGIN $bundle_id" \
      --subscribe "space.${sid}.app.${app_num}" aerospace_workspace_change
    ((app_num++))
  done
done

# Initial state
for sid in $(aerospace list-workspaces --all); do
  FOCUSED_WORKSPACE="$FOCUSED" "$PLUGIN" "$sid"
  app_num=0
  for bundle_id in $(aerospace list-windows --workspace "$sid" --format '%{app-bundle-id}' | sort -u); do
    NAME="space.${sid}.app.${app_num}" FOCUSED_WORKSPACE="$FOCUSED" "$APP_ICON_PLUGIN" "$bundle_id"
    ((app_num++))
  done
done
