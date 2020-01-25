#
# .profile -- Rich's machine-independent .profile
#

# Defaults prior to local settings
export COLORTERM="y"
export PAGER="less -r"
export IGNOREEOF=1
unset  MAILCHECK
unset  MAIL

export GOPATH=~/code/go

set +x

shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.bash_history_safe
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoreboth

if [ "${-/i/}" != "$-" ]; then
   INTERACTIVE=1
else
   INTERACTIVE=0
fi

export PATH=$HOME/.bash-my-aws/bin:$HOME/gbin:$HOME/bin:$GOPATH/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

# Read in local settings
for bashrc in /etc/bashrc /etc/bash.bashrc
do
   test -r $bashrc && source $bashrc
done

for ed in code subl rsub vim vi; do
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

# OS X sets this to a fancy dir-in-title that I don't want
unset PROMPT_COMMAND

# Global aliases. Don't use full paths.
alias fdate="date +%Y%m%d"
alias _='sudo -H'
alias _e='sudo -e'
alias _s='sudo -H -s'
alias add='xargs | sed "s/ /+/g" | bc -l'
alias ppjson='python -mjson.tool'
alias lf='ls -rt | tail -1'
alias tstamp='while read LINE; do echo "$(date +%H:%M:%S) $LINE"; done'
alias dstamp='while read LINE; do echo "$(date +%Y%m%d-%H:%M:%S) $LINE"; done'
alias hl="LESSOPEN='| source-highlight --outlang-def=esc256.outlang --style-file=esc256.style -i \"%s\"' LESS=' -R ' less"

alias bx="bundle exec"
alias ackc="ack --group --color"
alias ackp="ack --passthru"

alias awswho="aws sts get-caller-identity"

test -f $HOME/.bash-my-aws/aliases && source $HOME/.bash-my-aws/aliases aws

function pw {
   pwgen -ncBy ${1:-12} ${2:-1}
}

function cdto {
    DIR=$(dirname $1)
    cd $DIR
}

function tailgrep {
    PATTERN="$1";
    shift;
    tail -F $@ | grep --line-buffered "$PATTERN"
}

function avx
{
    profile=$1;
    shift;
    TYPE=$(type -t $1)
    case $TYPE in
    function|alias)
      aws-vault exec $profile -- bash -i -c "$@"
      ;;
    *)
      aws-vault exec $profile -- "$@"
    esac
}

if grep --help 2>&1 | grep --quiet color; then
	alias grep="grep --color=auto"
fi

if type gls >/dev/null 2>&1; then
    alias ls="gls --color=tty"
elif ls --help 2>&1 | grep --quiet color; then
	alias ls="ls --color=tty"
fi



if [ $TERM -a $TERM != 'dumb' ]; then
    poldon=$(tput bold)
    pboldoff=$(tput sgr0)
fi

# window title
if [ "$TERM" = "xterm" -o "$TERM" = "xterm-color" -o \
     "$TERM" = "rxvt"  -o "$TERM" = "xterm-256color" ]; then
  export COLORTERM="y"  #         MUTT needs this
  #PS1='\[\033]2;\u@\h: \w\007\033]1;\u@${\h}\007\]'
  WTITLE='\[\033]0;\u@\h: \w\007\]'
fi

# export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWSTASHSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=1
# export GIT_PS1_SHOWUPSTREAM="verbose"
# source ~/.git-prompt.sh

if [ -d "$HOME/.ssh" -a ! -d "$HOME/.ssh/controlmasters" ]; then
    mkdir $HOME/.ssh/controlmasters
fi

#########################################################################
#
# BEGIN INTERACTIVE SHELL BITS
#
#########################################################################
if [ $INTERACTIVE ]; then
  if [[ -d ~/.homesick/repos/git-aware-prompt ]]; then
    export GITAWAREPROMPT="$HOME/.homesick/repos/git-aware-prompt"
    # this also installs colors.sh
    #source "${GITAWAREPROMPT}/main.sh"
    source "${GITAWAREPROMPT}/colors.sh"
  fi

  if [[ -d ~/.homesick/repos/bash-git-prompt ]]; then
    source ~/.homesick/repos/bash-git-prompt/gitprompt.sh
  fi

  # In a git repo, bash-git-prompt's prompt magic replaces PS1 with
  # its own thing, but if GIT_PROMPT_START and GIT_PROMPT_END are defined
  # then it replaces PS1 with:
  #
  #   ${GIT_PROMPT_START}[...the git status...]${GIT_PROMPT_END}
  #
  # Since I want the status in the middle of my usual prompt, let's build PS1
  # using GIT_PROMPT_START and _END rather than having to build both.

  unset GIT_PROMPT_START
  unset GIT_PROMPT_END
  unset PS1

  GIT_PROMPT_START=$WTITLE'$(if [[ $? -eq 0 ]]
          then
              echo -e "\[${txtcyn}\]:)\[${txtrst}\]"
          else
              echo -e "\[${txtred}\]:(\[${txtrst}\]"
          fi) $(if [[ "$USER" = 'root' ]]
          then
              echo -e "\[${bldred}\]root\[${txtrst}\]@"
          elif [[ "$USER" != "rich" && "$USER" != "rlafferty" ]]
          then
              echo -e "\[${txtpur}\]$USER\[${txtrst}\]@"
          fi)'"\[${txtcyn}\]\h\[${txtwht}\]:\[${txtcyn}\]\W"

  GIT_PROMPT_END="\[$txtwht\]\\$\[$txtrst\] "

  PS1="${GIT_PROMPT_START}${GIT_PROMPT_END}"

  if [ "$TERM" = "dumb" ]; then
      PS1='\u@\h\$ '
  fi
  export PS1

  export MYSQL_PS1="\u@\h:\d> "

  HS_DIR="$HOME/.homesick/repos/homeshick/"

  if [[ -d "${HS_DIR}" ]]; then
    source ${HS_DIR}/homeshick.sh
    source ${HS_DIR}/completions/homeshick-completion.bash
    alias hs=homeshick
  fi

  for i in ~/.bash_completion.d/*; do
      source $i
  done

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

  if [ -e ~/.iterm2_shell_integration.bash ]; then
      source ~/.iterm2_shell_integration.bash
  fi

#  if [ -e ~/.rvm/scripts/rvm ]; then
#      source ~/.rvm/scripts/rvm
#  fi

  # this will loop endlessly if we don't check if
  if [[ -e ~/.rbenv && -z $RBENV_SHELL ]]; then
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
  fi

  if [ -e ~/gbin/colorssh ]; then
      alias ssh="colorssh"
  fi

fi  # END INTERACTIVE

# comes last to override
source ~/.profile-local


