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

hs_bin="${HOMESHICK_DIR:-$HOME/.homesick/repos/homeshick}/bin/homeshick"
if [[ ! -f "$HOME/.bashrc-daily-$(date +%Y%m%d)" && "$SHLVL" == "1" && -z "${SUDO_USER}" ]]; then
  rm -f "$HOME"/.bashrc-daily-*
  lockf -k -s -t 0 "$HOME/.bashrc-daily-$(date +%Y%m%d)" $hs_bin check
fi

#if [[ $BASH_VERSINFO -lt 5 ]]; then
#  echo "WARNING: Using old bash version: $BASH_VERSION"
#fi

# comes last to override
source ~/.profile-local
