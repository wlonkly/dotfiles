# 
# .profile -- Rich's machine-independent .profile
#

# Defaults prior to local settings
export EMACS_LOCATION="emacs"
export COLORTERM="y"
export PAGER="less -r"
export IGNOREEOF=1
unset  MAILCHECK
unset  MAIL

set +x

for ed in subl rsub vim vi; do
  FOUND=$(type -p $ed)
  if [[ -n $FOUND ]]; then
    export EDITOR=$FOUND
    break
  fi
done

shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.bash_history_safe
export HISTTIMEFORMAT='%F %T '

export HOMEBREW_GITHUB_API_TOKEN="e90782a0b3d7a76c88da0859265b394dc902d688"

# default username
ME=rich

export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

# Read in local settings
for bashrc in /etc/bashrc /etc/bash.bashrc
do
   test -r $bashrc && source $bashrc
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

function pw {
   pwgen -ncBy ${1:-12} ${2:-1}
}

function tailgrep {
    PATTERN="$1";
    shift;
    tail -F $@ | grep --line-buffered "$PATTERN"
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

# turns foo.ordpci.fbks.in into foo.ordpci
if echo $HOSTNAME | grep --quiet "\.fbks\.in$"; then
  SHORTHOST=$(echo $HOSTNAME | cut -d. -f1-2)
else
  SHORTHOST=$(echo $HOSTNAME | cut -d. -f1)
fi

export SHORTHOST

# window title
if [ "$TERM" = "xterm" -o "$TERM" = "xterm-color" -o \
     "$TERM" = "rxvt"  -o "$TERM" = "vs100" ]; then
  export COLORTERM="y"  #         MUTT needs this 
  #PS1='\[\033]2;\u@\h: \w\007\033]1;\u@${SHORTHOST}\007\]'
  WTITLE='\[\033]0;\u@\h: \w\007\]'
fi

# export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWSTASHSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=1
# export GIT_PS1_SHOWUPSTREAM="verbose"
# source ~/.git-prompt.sh

if [[ -d ~/.homesick/repos/git-aware-prompt ]]; then
  export GITAWAREPROMPT="$HOME/.homesick/repos/git-aware-prompt"
  # this also installs colors.sh 
  #source "${GITAWAREPROMPT}/main.sh"
  source "${GITAWAREPROMPT}/colors.sh"
fi

if [[ -d ~/.homesick/repos/bash-git-prompt ]]; then
  source ~/.homesick/repos/bash-git-prompt/gitprompt.sh
fi

GIT_PROMPT_START=$WTITLE'$(if [[ $? -eq 0 ]]
        then
            echo -e "\[${ccyan}\]:)\[${c}\]"
        else
            echo -e "\[${cred}\]:(\[${c}\]"
        fi) $(if [[ "$USER" = 'root' ]]
        then
            echo -e "\[${cbred}\]root\[${c}\]@"
        elif [[ "$USER" != "$ME" ]]
        then
            echo -e "\[${cmagenta}\]$USER\[${c}\]@"
        fi)'"\[${txtcyn}\]${SHORTHOST}\[${txtwht}\]:\[${txtcyn}\]\W"

GIT_PROMPT_END="\[$txtwht\]\$\[$txtrst\] "

PS1="${GIT_PROMPT_START}${GIT_PROMPT_END}"

###         fi)'"\[${txtcyn}\]${SHORTHOST}\[${txtwht}\]:\[${txtcyn}\]\W\[${txtylw}\]\$git_branch\[$txtred\]\$git_dirty\[$txtwht\]\$\[$txtrst\] "

if [ "$TERM" = "dumb" ]; then
    PS1='\u@\h\$ '
fi
export PS1 

export MYSQL_PS1="\u@${SHORTHOST}:\d> "

HS_DIR="$HOME/.homesick/repos/homeshick/"

if [[ -d "${HS_DIR}" ]]; then
  source ${HS_DIR}/homeshick.sh
  source ${HS_DIR}/completions/homeshick-completion.bash
  alias hs=homeshick
fi

if [ -d "$HOME/.ssh" -a ! -d "$HOME/.ssh/controlmasters" ]; then
    mkdir $HOME/.ssh/controlmasters
fi

source ~/.git-completion.bash

# comes last to override
source ~/.profile-local


