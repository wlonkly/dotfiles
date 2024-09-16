#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title No Fifth Symbols
# @raycast.mode fullOutput

# @raycast.icon 🐬

# @raycast.description Avoids any fifth symbol in input
# @raycast.author Rich Lafferty
# @raycast.authorURL https://github.com/wlonkly/

clipboard_command=$(ls -1 /usr/bin/pbp*)
input=$($clipboard_command)

fifth_symbol=$'\x65'
fifth_symbol_caps=$'\x45'
ok=$'\342\234\205'
kaboom=$'\342\235\214'
crimson="\x1b[31m"
normal="\x1b[0m"

output="${input//${fifth_symbol}/${crimson}${fifth_symbol}${normal}}"
output="${output//${fifth_symbol_caps}/${crimson}${fifth_symbol_caps}${normal}}"
[[ "${input}" != "${output}" ]] && printf "${kaboom} ${output}\n" || printf "${ok} ${output}\n"
