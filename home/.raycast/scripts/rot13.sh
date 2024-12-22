#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title rot13
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔄
# @raycast.argument1 { "type": "text", "placeholder": "Text to encode", "optional": true }

# Documentation:
# @raycast.description performs rot13 on clipboard
# @raycast.author wlonkly
# @raycast.authorURL https://raycast.com/wlonkly

if [[ $1 ]]; then
  echo "$1"
else
  pbpaste
fi | tr 'A-Za-z' 'N-ZA-Mn-za-m'
