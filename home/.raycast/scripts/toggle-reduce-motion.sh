#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Reduce Motion
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Toggles "Reduce Motion"
# @raycast.author Rich Lafferty
# @raycast.authorURL https://github.com/wlonkly/

notify () {
  state=$1
  terminal-notifier -sender com.raycast.macos -title "Reduce Motion" -ignoreDnD -message "Reduce motion ${state}"
}

shortcuts run "Toggle Reduce Motion"

STATUS=$(defaults read com.apple.universalaccess reduceMotion)

if [[ $STATUS == 1 ]]; then
  notify enabled
else
  notify disabled
fi
