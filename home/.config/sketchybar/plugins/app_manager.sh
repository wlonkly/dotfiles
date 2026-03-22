#!/usr/bin/env bash

# Rebuild app icon items for all workspaces on workspace change
# Only adds/removes items that have changed and updates all icons

CONFIG_DIR="$HOME/.config/sketchybar"
source "$HOME/.config/sketchybar/colors.sh"
APP_ICON_PLUGIN="$CONFIG_DIR/plugins/app_icon.sh"
LOCKFILE="/tmp/sketchybar_app_manager.pid"

echo "running app_manager.sh"

# PID lock with timeout
if [ -f "$LOCKFILE" ]; then
  OLDPID=$(cat "$LOCKFILE")
  if kill -0 "$OLDPID" 2>/dev/null; then
    if [ $(( $(date +%s) - $(stat -f %m "$LOCKFILE") )) -lt 5 ]; then
      exit 0
    fi
  fi
fi

echo $$ > "$LOCKFILE"

# Get current items
current_items=$(sketchybar --query bar | jq -r '.items[]' | grep '\.app\.' | sort)

# Process each workspace
for sid in $(aerospace list-workspaces --all); do
  bundle_ids=$(aerospace list-windows --workspace "$sid" --format '%{app-bundle-id}' | sort -u)
  app_num=0
  for bundle_id in $bundle_ids; do
    item_name="space.${sid}.app.${app_num}"
    # Check if item exists
    if ! echo "$current_items" | grep -q "^$item_name\$"; then
      # Create new item - NO event subscription to avoid extra script runs
      sketchybar --add item "$item_name" left \
        --set "$item_name" \
          icon.font="sketchybar-app-font:Regular:14.0" \
          icon.color=$ICON_COLOR \
          icon.padding_left=4 \
          icon.padding_right=4 \
          background.height=20 \
          label.drawing=off \
          background.drawing=on \
          padding_left=0 \
          padding_right=0
      sketchybar --move "$item_name" after "space.${sid}" 2>/dev/null
    fi
    # Always update the icon
    NAME="$item_name" "$APP_ICON_PLUGIN" "$bundle_id"
    ((app_num++))
  done
done

# Remove items that no longer exist
current_items=$(sketchybar --query bar | jq -r '.items[]' | grep '\.app\.' | sort)
desired_items=""
for sid in $(aerospace list-workspaces --all); do
  bundle_ids=$(aerospace list-windows --workspace "$sid" --format '%{app-bundle-id}' | sort -u)
  app_num=0
  for bundle_id in $bundle_ids; do
    desired_items="$desired_items space.${sid}.app.${app_num}"
    ((app_num++))
  done
done

for item in $current_items; do
  if ! echo "$desired_items" | grep -q "$item"; then
    sketchybar --remove "$item" 2>/dev/null
  fi
done

rm -f "$LOCKFILE"
