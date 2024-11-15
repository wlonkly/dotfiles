#!/bin/bash

date >> /tmp/rgb.log

PATH=/opt/homebrew/bin:$PATH
export PATH

current=$(betterdisplaycli get -namelike=dell -connectionMode);
current=${current%% -*};

rgb=$(betterdisplaycli get -namelike=dell -connectionModeList | grep 'RGB Full');
rgb=${rgb%% -*};

if [[ "$current" != "$rgb" ]]; then
    terminal-notifier -message "Fixing Dell RGB mode in 5s"
    sleep 5 
    betterdisplaycli set -namelike=dell -connectionMode=${rgb};
fi
