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
for ed in code subl vim vi; do
  found=$(type -p $ed)
  if [[ -n $found ]]; then
    if [[ "$(basename $found)" = "subl" ]]; then
        export EDITOR="$found -nw"
    elif [[ "$(basename $found)" = "code" ]]; then
        export EDITOR="$found -w"
    else
        export EDITOR=$found
    fi
    break
  fi
  unset found
done

if [ ! -f ~/.bashrc-daily-$(date +%Y%m%d) -a -z "$SUBSHELL" ]; then
  rm -f ~/.bashrc-daily-*
  touch ~/.bashrc-daily-$(date +%Y%m%d)
  homeshick check
  # echo
  #$HOME/gbin/vscode-settings-check
fi

# comes last to override
source ~/.profile-local
