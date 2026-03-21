#!/usr/bin/env bash

# Called with: app_icon.sh <bundle_id>
# Returns the icon glyph for the given app bundle ID

source "$HOME/.config/sketchybar/icon_map.sh"

icon_map "$1"
sketchybar --set "$NAME" icon="$icon"
