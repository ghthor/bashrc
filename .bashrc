export PROJ=$HOME/proj
export EDITOR=vim
export CLICOLOR=""

export QMK_ROOT=$PROJ/hid/qmk_firmware
export QMK_CUSTOM=$QMK_ROOT/keyboards/ergodox_ez/keymaps

export WINEPREFIX=$HOME/.wine-dnd/
export WINEARCH=win32

# Fix TERM variable
if [ "$TERM" == "xterm" ]; then
  TERM=xterm-256color
fi

# src: https://unix.stackexchange.com/a/217629
pathmunge() {
  if [ -d "$1" ]; then
    if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)"; then
      if [ "$2" = "after" ]; then
        PATH="$PATH:$1"
      else
        PATH="$1:$PATH"
      fi
    fi
  fi
}

binPaths=(
  "$HOME/.local/bin"
  "$GOPATH/bin"
  "$GOROOT/bin"
  "$HOME/bin/go-dev-tools"
  "$HOME/bin"
)

for dir in "${binPaths[@]}"; do
  pathmunge "$dir"
done

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Homebrew bash completion
command -v brew 2>&1 >/dev/null &&
  [[ -f $(brew --prefix)/etc/bash_completion ]] &&
  . $(brew --prefix)/etc/bash_completion

# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Prompt colors
_txt_col="\e[00m"    # Std text (white)
_bld_col="\e[01;37m" # Bold text (white)
_wrn_col="\e[01;31m" # Warning
_sep_col=$_txt_col   # Separators
_usr_col="\e[01;32m" # Username
_cwd_col=$_txt_col   # Current directory
_hst_col="\e[0;32m"  # Host
_env_col="\e[0;36m"  # Prompt environment
_git_col="\e[01;36m" # Git branch

# Returns the current git branch (returns nothing if not a git repository)
parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_dirty() {
  [[ $(git status 2>/dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "±"
}

# Returns the current ruby version.
parse_ruby_version() {
  if (which ruby | grep -q ruby); then
    ruby -v | cut -d ' ' -f2
  fi
}

# Set the terminal title string
# Looks like this:
#     user@hostname: ~/current/working/directory
#
# Set the prompt string (PS1)
# Looks like this:
#     user@hostname ~/current/working/directory [master|1.8.7]$

# (Prompt strings need '\['s around colors.)
set_ps1() {
  term_title_str="\[\033]0;\u@\h: \w\007\]"
  user_str="\[$_usr_col\]\u\[$_hst_col\]@\h\[$_txt_col\]"
  dir_str="\[$_cwd_col\]\w"

  git_branch=$(parse_git_branch)
  git_dirty=$(parse_git_dirty)
  git_str="\[$_git_col\]$git_branch\[$_wrn_col\]$git_dirty"

  if [ -n "$GOPATH" ]; then
    gopath_str="$(basename $GOPATH)"
  else
    unset gopath_str
  fi

  # Git & Gopath
  if [ -n "$git_branch" ] && [ -n "$gopath_str" ]; then
    env_str=" \[$_env_col\][$git_str\[$_env_col\]]($gopath_str)"
    # Just Git
  elif [ -n "$git_branch" ]; then
    env_str=" \[$_env_col\][$git_str\[$_env_col\]]"
    # Just Gopath
  elif [ -n "$gopath_str" ]; then
    env_str=" \[$_env_col\]($gopath_str)"
  else
    unset env_str
  fi

  # < username >@< hostname > < current directory > [< git branch >|< ruby version >]
  case $TERM in
  xterm*)
    PS1="$term_title_str$user_str $dir_str$env_str\n\[$_sep_col\]$ \[$_txt_col\]"
    ;;
  *)
    PS1='[\u@\h \W]\$ '
    ;;
  esac
}

# Set custom prompt
PROMPT_COMMAND='set_ps1;'

# Set GREP highlight color
export GREP_COLOR='1;32'

# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Function definitions
if [ -f "$HOME/.bash_funcs" ]; then
  . "$HOME/.bash_funcs"
fi

set -o vi

# Setup SCM Breeze
[[ -s "$HOME/.scm_breeze/scm_breeze.sh" ]] && . "$HOME/.scm_breeze/scm_breeze.sh"

# Setup autojump support
# Arch
[[ -s "/usr/share/autojump/autojump.bash" ]] && . "/usr/share/autojump/autojump.bash"
# OSX
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

# Setup nvm
[[ -s "/usr/share/nvm/init-nvm.sh" ]] && . "/usr/share/nvm/init-nvm.sh"

# Setup fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
