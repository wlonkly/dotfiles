#!/usr/bin/env bash
#
# .bash_profile runs for LOGIN shells only
# note that OS X terminals and ssh sessions are login shells, but xterms usually aren't
#

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

BASH_ENV=$HOME/.bashrc

# editors, in order of preference
for ed in code vim vi; do
  found=$(type -p $ed)
  if [[ -n $found ]]; then
    if [[ "$(basename "$found")" = "subl" ]]; then
        export EDITOR="$found -nw"
    elif [[ "$(basename "$found")" = "code" ]]; then
        export EDITOR="$found -w"
    else
        export EDITOR=$found
    fi
    break
  fi
  unset found
done

# ssh-add -L returns false if no identities present. handy
ssh-add -L >/dev/null || ssh-add -A 2>&1 | grep -v "Identity added"

if [[ ! -f "$HOME/.bashrc-daily-$(date +%Y%m%d)" && -z "$SUBSHELL" ]]; then
  rm -f "$HOME"/.bashrc-daily-*
  touch "$HOME/.bashrc-daily-$(date +%Y%m%d)"
  homeshick check
  # echo
  #$HOME/gbin/vscode-settings-check
fi

#if [[ $BASH_VERSINFO -lt 5 ]]; then
#  echo "WARNING: Using old bash version: $BASH_VERSION"
#fi

# comes last to override
source ~/.profile-local
