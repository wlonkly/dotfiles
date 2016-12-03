# 
# .profile -- Rich's machine-independent .profile
#

# Defaults prior to local settings
export EMACS_LOCATION="emacs"
export COLORTERM="y"
export PAGER="less -r"
export IGNOREEOF=1
export EDITOR="vim"
unset  MAILCHECK
unset  MAIL

shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.bash_history_safe
export HISTTIMEFORMAT='%F %T '

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

if grep --help 2>&1 | grep --quiet color
then
	alias grep="grep --color=auto"
fi

if type gls >/dev/null; then
    alias ls="gls --color=tty"
elif ls --help 2>&1 | grep --quiet color; then 
	alias ls="ls --color=tty"
fi

if [ $TERM -a $TERM != 'dumb' ]; then
    pboldon=$(tput bold)
    pboldoff=$(tput sgr0)
fi

# turns foo.ordpci.fbks.in into foo.ordpci
if echo $HOSTNAME | grep --quiet "\.fbks\.in$"; then
  SHORTHOST=$(echo $HOSTNAME | cut -d. -f1-2)
else
  SHORTHOST=$(echo $HOSTNAME | cut -d. -f1)
fi
export SHORTHOST


PS1="\[$pboldon\]\w\[$pboldoff\]\n"

# window title
if [ "$TERM" = "xterm" -o "$TERM" = "xterm-color" -o \
     "$TERM" = "rxvt"  -o "$TERM" = "vs100" ]
  then
    export COLORTERM="y"  #         MUTT needs this 
    #PS1='\[\033]2;\u@\h: \w\007\033]1;\u@${SHORTHOST}\007\]'
    WTITLE='\[\033]0;\u@\h: \w\007\]'
fi

PS1=$WTITLE':$(if [[ $? -eq 0 ]]
        then
            echo ")"
        else
            echo "("
        fi) $(if [[ _$USER = '_root' ]]
        then
            echo "\[$pboldon\]$USER\[$pboldoff\]@"
        elif [[ _$USER != _$ME ]]
        then
            echo "$USER@"
        fi)\h:\w\$ '

if [ "$TERM" = "dumb" ]
  then
    PS1='\u@\h\$ '
fi
export PS1 

export MYSQL_PS1="\u@${SHORTHOST}:\d> "

# comes last to override
source ~/.profile-local


