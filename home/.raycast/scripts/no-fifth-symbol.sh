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

fifth_symbol=$'\x65'
fifth_symbol_caps=$'\x45'
ok=$'\342\234\205'
kaboom=$'\342\235\214'
crimson="\x1b[31m"
normal="\x1b[0m"

[[ ${input} == *"${fifth_symbol}"* ]] && symbol=${fifth_symbol}
[[ ${input} == *"${fifth_symbol_caps}"* ]] && symbol=${fifth_symbol_caps}
[[ -n ${symbol} ]] && printf "${kaboom} ${input/${symbol}/${crimson}${symbol}${normal}}\n" || printf "${ok} ${input}\n"
