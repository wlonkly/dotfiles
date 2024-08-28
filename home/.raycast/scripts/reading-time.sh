#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reading Time
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📖

# Documentation:
# @raycast.author Rich Lafferty
# @raycast.authorURL https://github.com/wlonkly/

minutes=$(( ( $(pbpaste | wc -w) / 200) + 1))
echo "${minutes} min"
