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

words=$(pbpaste | wc -w)
minutes=$(echo "scale=2;${words} / 200" | bc -l)

echo "${minutes} minutes"
