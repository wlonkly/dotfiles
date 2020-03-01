#
# .bashrc runs for interactive, non-login shells, aka "stuff that we want
# in subshells"
#

# Defaults prior to local settings
export PATH=$HOME/.bash-my-aws/bin:$HOME/gbin:$HOME/bin:$GOPATH/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

unset MAILCHECK
unset MAIL

export COLORTERM="y"
export PAGER="less -r"
export IGNOREEOF=1
export GOPATH=~/code/go
export FCEDIT=vi

# history file
shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.bash_history_safe
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoreboth

# Read in local settings
for bashrc in /etc/bashrc /etc/bash.bashrc
do
  test -r $bashrc && source $bashrc
done

# OS X sets this to a fancy dir-in-title that I don't want
unset PROMPT_COMMAND

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
alias whois="whois -h geektools.com"

test -f $HOME/.bash-my-aws/aliases && source $HOME/.bash-my-aws/aliases
test -f $HOME/.bash-my-aws/bash_completion.sh && source $HOME/.bash-my-aws/bash_completion.sh

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

function flatten
{
  ruby -e 'p ARGF.read.gsub("\r", "")' "$@"
}

if grep --help 2>&1 | grep --quiet color; then
	alias grep="grep --color=auto"
fi

if type gls >/dev/null 2>&1; then
  alias ls="gls --color=tty"
elif ls --help 2>&1 | grep --quiet color; then
	alias ls="ls --color=tty"
fi

test -d "$HOME/.ssh" && mkdir -p $HOME/.ssh/controlmasters

test -e ~/gbin/colorssh && alias ssh="colorssh"

if type bat &> /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

source ~/.bash_prompt
