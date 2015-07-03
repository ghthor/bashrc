export PROJ=$HOME/proj
export GAMESLAB=$PROJ/gameslab

export GOBIN=$HOME/bin
export GOPATH=$PROJ/go
export go_github=$GOPATH/src/github.com
export go_bitbucket=$GOPATH/src/bitbucket.org

export EDITOR=vim

# Fix TERM variable
if [ "$TERM" == "xterm" ] ; then
    TERM=xterm-256color
fi

# Add Home bin dir to path
if [[ -d "$HOME/bin"  && ":$PATH:" != *":$HOME/bin:"* ]] ; then
    PATH=$HOME/bin:$PATH
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Prompt colors
_txt_col="\e[00m"     # Std text (white)
_bld_col="\e[01;37m"  # Bold text (white)
_wrn_col="\e[01;31m"  # Warning
_sep_col=$_txt_col    # Separators
_usr_col="\e[01;32m"  # Username
_cwd_col=$_txt_col    # Current directory
_hst_col="\e[0;32m"   # Host
_env_col="\e[0;36m"   # Prompt environment
_git_col="\e[01;36m"  # Git branch

# Returns the current git branch (returns nothing if not a git repository)
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "±"
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
  user_str="\[$_usr_col\]\u\[$_hst_col\]@\h\[$_txt_col\]"
  dir_str="\[$_cwd_col\]\w"
  git_branch=`parse_git_branch`
  git_dirty=`parse_git_dirty`
  #ruby=`parse_ruby_version`

  git_str="\[$_git_col\]$git_branch\[$_wrn_col\]$git_dirty"
  # Git repo & ruby version
  if [ -n "$git_branch" ] && [ -n "$ruby" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]|$ruby]"
  # Just git repo
  elif [ -n "$git_branch" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]]"
  # Just ruby version
  elif [ -n "$ruby" ]; then
    env_str="\[$_env_col\][$ruby]"
  else
    unset env_str
  fi

  # < username >@< hostname > < current directory > [< git branch >|< ruby version >]
  case $TERM in
      xterm*)
          PS1="\[\033]0;\u@\h: \w\007\]$user_str $dir_str $env_str\[$_sep_col\]$ \[$_txt_col\]"
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
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Function definitions
if [ -f ~/.bash_funcs ]; then
    . ~/.bash_funcs
fi

set -o vi

# SCM Breeze
[[ -s "$HOME/.scm_breeze/scm_breeze.sh" ]] && . "$HOME/.scm_breeze/scm_breeze.sh"
