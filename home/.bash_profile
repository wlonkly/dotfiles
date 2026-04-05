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
_hs_daily="$HOME/.bashrc-daily-$(date +%Y%m%d)"
_hs_lock="$HOME/.bashrc-daily.lock"

if [[ "$SHLVL" == "1" && -z "${SUDO_USER}" && ! -f "$_hs_daily" ]]; then
  # outside -f above is just a quick failure - the real 
  # locking is done below
  lockf -k -s -t 0 "$_hs_lock" \
    env _hs_daily="$_hs_daily" _hs_bin="$hs_bin" \
    bash -c '
      [[ -f "$_hs_daily" ]] && exit 0
      rm -f "${HOME}/.bashrc-daily-"[0-9]*
      touch "$_hs_daily"
      "$_hs_bin" check
    '
fi

#if [[ $BASH_VERSINFO -lt 5 ]]; then
#  echo "WARNING: Using old bash version: $BASH_VERSION"
#fi

# comes last to override
source ~/.profile-local
