#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quit OBS
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎥

# Documentation:
# @raycast.description Quits OBS
# @raycast.author Rich Lafferty
# @raycast.authorURL https://github.com/wlonkly/

OUT=$(osascript -e 'tell application "OBS" to quit')

if test -z "$OUT" || echo "$OUT" | grep --quiet "execution error: OBS got an error: User canceled"; then
    echo "OBS has exited"
else
    echo "OBS failed to exit: $OUT"
fi
