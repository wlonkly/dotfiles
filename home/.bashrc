#!/usr/bin/env bash
#
# shellcheck disable=SC1090
#
# .bashrc runs for interactive, non-login shells, aka "stuff that we want
# in subshells"
#

# Defaults prior to local settings
unset MAILCHECK
unset MAIL

export COLORTERM="y"
export PAGER="less -r"
export IGNOREEOF=1
export GOPATH=~/code/go
export FCEDIT=vi
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export HOMEBREW_BUNDLE_FILE=~/.brewfile
export HOMEBREW_NO_AUTO_UPDATE=1
export SHORTHOST=${HOSTNAME/\.*/}
export MYSQL_PS1="\u@\h:\d> "
export PS2="..."

export PATH=$HOME/.bash-my-aws/bin:$HOME/gbin:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH
export CDPATH=.:$HOME:$HOME/code

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

alias fdate="date +%Y%m%d"
alias _='sudo -H'
alias _e='sudo -e'
alias _s='sudo -H -s'
alias add='xargs | sed "s/ /+/g" | bc -l'
alias ppjson='python -mjson.tool'
alias tstamp='while read LINE; do echo "$(date +%H:%M:%S) $LINE"; done'
alias dstamp='while read LINE; do echo "$(date +%Y%m%d-%H:%M:%S) $LINE"; done'
alias hl="LESSOPEN='| source-highlight --outlang-def=esc256.outlang --style-file=esc256.style -i \"%s\"' LESS=' -R ' less"
alias bx="bundle exec"
alias bi="MAKEFLAGS='-j 4' bundle install --jobs=4"
alias ackc="ack --group --color"
alias ackp="ack --passthru"
alias rgc="rg --heading --color=always"
alias rgp="rg --passthru"
alias awswho="aws sts get-caller-identity"
alias tf="terraform"
alias 1p="op"
alias terminate="aws ec2 terminate-instances --instance-ids"
alias cdtop='cd "$(git rev-parse --show-toplevel)"'
alias dg='dig +nocmd +nocomments +noquestion +nostats +multiline'
alias d-c='docker compose'
#alias altscr="printf '\e[?1049h'"
#alias mainscr="printf '\e[?1049l'"
alias altscr="tput smcup"
alias mainscr="tput rmcup"
alias myip="dig +short ip. @dns.toys | sed 's/\"//g'"

alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
alias kubeclr="kubectl config unset current-context"
complete -F __start_kubectl k

# ubuntu why
test -x /usr/bin/batcat && alias bat="batcat"

test -f "$HOME/.bash-my-aws/aliases" && source "$HOME/.bash-my-aws/aliases"
test -f "$HOME/.bash-my-aws/bash_completion.sh" && source "$HOME/.bash-my-aws/bash_completion.sh"

function wordle {
  command grep "^${1}$" /usr/share/dict/words \
    | command grep -v "[${2:-0}]"
}

function lf {
  # shellcheck disable=SC2012
  ls -rt | tail -n "${1:-1}"
}

function pw {
  pwgen -ncBy "${1:-12}" "${2:-1}"
}

function cdto {
  DIR=$(dirname "$1")
  cd "$DIR" || return 1
}

function tailgrep {
  PATTERN="$1";
  shift;
  tail -F "$@" | grep --line-buffered "$PATTERN"
}

function rhist {
  rg -aN "$*" $HISTFILE
}


function pbcopy {
  cat "$@" | command pbcopy
}

function avx
{
  profile="$1";
  shift;
  TYPE=$(type -t "$1")
  case $TYPE in
  function|alias)
    aws-vault exec "$profile" -- bash -i -c "$@"
    ;;
  *)
    aws-vault exec "$profile" -- "$@"
  esac
}

function aox
{
  profile="$1";
  shift;
  TYPE=$(type -t "$1")
  case $TYPE in
  function|alias)
    aws-okta exec "$profile" -- bash -i -c "$@"
    ;;
  '')
    aws-okta exec "$profile" -- "$SHELL"
    ;;
  *)
    aws-okta exec "$profile" -- "$@"
  esac
}

function flatten
{
  ruby -e 'p ARGF.read.gsub("\r", "")' "$@"
}

function starship_precmd_func
{
    # set xterm window title
    echo -ne "\033]0;${USER}@${SHORTHOST}\007"

    # populate AWS_VAULT from okta profile
    if [[ -z $AWS_VAULT && $AWS_OKTA_PROFILE ]]; then
        export AWS_VAULT=$AWS_OKTA_PROFILE
    fi
}

function fd {
  local dir
  dir=$(find "${1:-.}" -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir" || return 1
}

# use side-by-side mode in delta(1) if the terminal is wide enough
export DELTA_FEATURES
function delta_sidebyside {
  if [[ COLUMNS -ge 120 ]]; then
    DELTA_FEATURES='side-by-side'
  else
    DELTA_FEATURES=''
  fi
}
trap delta_sidebyside WINCH

if grep --help 2>&1 | grep --quiet color; then
  alias grep="grep --color=auto"
fi

# shellcheck disable=SC2010
if type gls >/dev/null 2>&1; then
  alias ls="gls --color=tty --quoting-style=literal"
elif ls --help 2>&1 | grep --quiet color; then
  alias ls="ls --color=tty --quoting-style=literal"
fi

test -e ~/gbin/colorssh && alias ssh="colorssh"

MANBAT=$(command -v batcat || command -v bat)
if [[ $MANBAT ]]; then
  export MANPAGER="sh -c 'col -bx | $MANBAT -l man -p'"
fi

HS_DIR="$HOME/.homesick/repos/homeshick/"

if [[ -d "${HS_DIR}" ]]; then
  source "${HS_DIR}/homeshick.sh"
  source "${HS_DIR}/completions/homeshick-completion.bash"
  alias hs=homeshick
fi

for i in ~/.bash_completion.d/* /opt/homebrew/bash_completion.d/*; do
  # the test handles the case where the wildcard expands to nothing
  test -f "$i" && source "$i"
done

# for ControlMaster
test -d "$HOME/.ssh/controlmasters" && rmdir "$HOME/.ssh/controlmasters"
mkdir -p "$HOME/.ssh/c"

# https://iterm2.com/documentation-scripting-fundamentals.html
function iterm2_print_user_vars {
    local profile="${AWS_VAULT:+${AWS_VAULT}@${AWS_REGION}}"
    if [[ "$profile" ]]; then
        iterm2_set_user_var awsProfile "☁️ $profile"
    else
        iterm2_set_user_var awsProfile ''
    fi

    local context=$(kubectl config view --minify -o jsonpath='{.current-context}/{..namespace}' 2>/dev/null)
    if [[ "$context" ]]; then
        iterm2_set_user_var kubeCtx "☸️ $context"
    else
        iterm2_set_user_var kubeCtx ''
    fi
}

[[ -r ~/.iterm2_shell_integration.bash ]] && source ~/.iterm2_shell_integration.bash

if [[ -e "${HOME}/.cargo/env" ]]; then
  source "${HOME}/.cargo/env"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

if command -v starship >/dev/null 2>&1; then
  export starship_precmd_user_func="starship_precmd_func"
  eval "$(starship init bash)"
fi

