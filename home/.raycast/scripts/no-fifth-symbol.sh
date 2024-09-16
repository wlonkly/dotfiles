#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title No Fifth Symbols
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🐬

# Documentation:
# @raycast.description Avoids any fifth symbol in input
# @raycast.author Rich Lafferty
# @raycast.authorURL https://github.com/wlonkly/

clipboard_command=$(ls -1 /usr/bin/pbp*)
input=$($clipboard_command)

if echo $input | grep --quiet e; then
    echo -e "❌ $(echo $input | sed 's/e/\\033[31me\\033[0m/g')"
else
    echo "✅ $input"
fi
