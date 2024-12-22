#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Cast to TV
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ▶️
# @raycast.argument1 { "type": "text", "placeholder": "Youtube URL", "optional": true }

# Documentation:
# @raycast.description calls ytcast with provided URL
# @raycast.author wlonkly
# @raycast.authorURL https://raycast.com/wlonkly

# https://www.youtube.com/watch?v=kwlAig-5e0w&pp=ygUYY2hvcmFsIGNvbmNlcnQgY2hyaXN0bWFz

# use argument if supplied, otherwise pbpaste
URL="$1"
if [ -z "$URL" ]; then
  URL=$(pbpaste)
fi

${HOME}/bin/ytcast -p "${URL}"
