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
  FOUND=$(type -p $ed)
  if [[ -n $FOUND ]]; then
    if [[ "$(basename $FOUND)" = "subl" ]]; then
        export EDITOR="$FOUND -nw"
    elif [[ "$(basename $FOUND)" = "code" ]]; then
        export EDITOR="$FOUND -w"
    else
        export EDITOR=$FOUND
    fi
    break
  fi
done

test -f $HOME/.bash-my-aws/aliases && source $HOME/.bash-my-aws/aliases
test -f $HOME/.bash-my-aws/bash_completion.sh && source $HOME/.bash-my-aws/bash_completion.sh

HS_DIR="$HOME/.homesick/repos/homeshick/"

if [[ -d "${HS_DIR}" ]]; then
  source ${HS_DIR}/homeshick.sh
  source ${HS_DIR}/completions/homeshick-completion.bash
  alias hs=homeshick
fi

if [ ! -f ~/.bashrc-daily-$(date +%Y%m%d) -a -z "$SUBSHELL" ]; then
  rm -f ~/.bashrc-daily-*
  touch ~/.bashrc-daily-$(date +%Y%m%d)
  homeshick check
  # echo
  #$HOME/gbin/vscode-settings-check
fi

for i in ~/.bash_completion.d/*; do
  # the test handles the case where the wildcard expands to nothing
  test -f $i && source $i
done

# for ControlMaster
test -d $HOME/.ssh/controlmasters && rmdir $HOME/.ssh/controlmasters
mkdir -p $HOME/.ssh/c

test -e ~/.iterm2_shell_integration.bash && source ~/.iterm2_shell_integration.bash

# comes last to override
source ~/.profile-local
