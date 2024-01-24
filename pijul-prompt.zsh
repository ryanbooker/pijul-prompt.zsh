# MIT License
#
# Copyright © 2023 Wolfgang Popp
# pijul-prompt.zsh changes Copyright © 2024 Ryan Booker
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

autoload -Uz colors && colors

# SETTINGS ---------------------------------------------------------------------
# Directly assigned to ensure that sourcing will reset the prompt

: "${ZSH_PIJUL_PROMPT_AWK_CMD=""}"
: "${ZSH_PIJUL_PROMPT_FORCE_BLANK=""}"
: "${ZSH_PIJUL_PROMPT_NO_ASYNC=""}"

# THEMING ----------------------------------------------------------------------
# Directly assigned to ensure that sourcing will reset the prompt

# Primary status
: "${ZSH_PIJUL_PROMPT_SHOW_REMOTE=""}"
: "${ZSH_PIJUL_PROMPT_SHOW_LOCAL_COUNTS="1"}"

: "${ZSH_THEME_PIJUL_PROMPT_PREFIX="["}"
: "${ZSH_THEME_PIJUL_PROMPT_SUFFIX="] "}"
: "${ZSH_THEME_PIJUL_PROMPT_SEPARATOR="|"}"
: "${ZSH_THEME_PIJUL_PROMPT_CHANNEL="%{$fg_bold[magenta]%}"}"
: "${ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL="%{$fg_bold[yellow]%}⟳ "}"
: "${ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING=""}"
: "${ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"}"
: "${ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX="%{$fg[red]%})"}"
: "${ZSH_THEME_PIJUL_PROMPT_CHANGED="%{$fg[blue]%}∆"}"
: "${ZSH_THEME_PIJUL_PROMPT_ADDED="%{$fg[green]%}+"}"
: "${ZSH_THEME_PIJUL_PROMPT_REMOVED="%{$fg[red]%}−"}"
: "${ZSH_THEME_PIJUL_PROMPT_RESURRECTED="✝"}"
: "${ZSH_THEME_PIJUL_PROMPT_SOLVED="%{$fg[magenta]%}⛙"}"
: "${ZSH_THEME_PIJUL_PROMPT_UNSOLVED="%{$fg[yellow]%}×"}"
: "${ZSH_THEME_PIJUL_PROMPT_UNTRACKED="…"}"
: "${ZSH_THEME_PIJUL_PROMPT_CLEAN="%{$fg_bold[green]%}✔"}"

# Secondary status
: "${ZSH_PIJUL_PROMPT_ENABLE_SECONDARY=""}"

: "${ZSH_THEME_PIJUL_PROMPT_SECONDARY_PREFIX=""}"
: "${ZSH_THEME_PIJUL_PROMPT_SECONDARY_SUFFIX=""}"
: "${ZSH_THEME_PIJUL_PROMPT_TAGS_SEPARATOR=", "}"
: "${ZSH_THEME_PIJUL_PROMPT_TAGS_PREFIX="# "}"
: "${ZSH_THEME_PIJUL_PROMPT_TAGS_SUFFIX=""}"
: "${ZSH_THEME_PIJUL_PROMPT_TAG="%{$fg_bold[yellow]%}"}"

# DEFAULT PROMPT ---------------------------------------------------------------

# Disable promptinit if it is loaded
(( $+functions[promptinit] )) && { promptinit; prompt off }

# Allow parameter and command substitution in the prompt
setopt PROMPT_SUBST

# Override PROMPT if it does not use the pijul_prompt function
[[ "$PROMPT" != *pijul_prompt* && "$RPROMPT" != *pijul_prompt* ]] \
  && PROMPT='%B%40<..<%~ %b$(pijul_prompt)$(pijul_prompt_secondary)' \
  && PROMPT+='%(?.%(!.%F{white}❯%F{yellow}❯%F{red}.%F{blue}❯%F{cyan}❯%F{green})❯.%F{red}❯❯❯)%f ' \
  && RPROMPT=''

# COMMANDS ---------------------------------------------------------------------

# Find an awk implementation
# Prefer nawk over mawk and mawk over awk
(( $+commands[mawk] )) && : "${ZSH_PIJUL_PROMPT_AWK_CMD:=mawk}"
(( $+commands[nawk] )) && : "${ZSH_PIJUL_PROMPT_AWK_CMD:=nawk}"
                          : "${ZSH_PIJUL_PROMPT_AWK_CMD:=awk}"

function _zsh_pijul_prompt_pijul_channel_cmd() {
  command pijul channel 2>/dev/null \
    || echo "fatal: pijul channel command failed"
}

function _zsh_pijul_prompt_pijul_latest_state_cmd() {
  command pijul log --state --limit 1 2>/dev/null \
    || echo "fatal: pijul latest state command failed"
}

function _zsh_pijul_prompt_pijul_remote_cmd() {
  command pijul remote 2>/dev/null \
    || echo "fatal: pijul remote command failed"
}

function _zsh_pijul_prompt_pijul_status_cmd() {
  command pijul diff --short --untracked 2>/dev/null \
    || echo "fatal: pijul status command failed"
}

function _zsh_pijul_prompt_pijul_tags_cmd() {
  command pijul tag 2>/dev/null \
    || echo "fatal: pijul tags command failed"
}

# PROMPT GENERATION ------------------------------------------------------------

function _zsh_pijul_prompt_pijul_status() {
  emulate -L zsh

  local channel
  channel=$(_zsh_pijul_prompt_pijul_channel_cmd | sed -n 's/^\* //p')

  # Until it's possible to retrieve the default remote, take the first listed.
  # This will not necessarily be the default remote, but rather the first remote
  # added to the repository.
  local remote
  remote=$(_zsh_pijul_prompt_pijul_remote_cmd | sed -En 's/^.*: (.*@)?//p' | head -n 1)

  _zsh_pijul_prompt_pijul_status_cmd | $ZSH_PIJUL_PROMPT_AWK_CMD \
    -v PREFIX="$ZSH_THEME_PIJUL_PROMPT_PREFIX" \
    -v SUFFIX="$ZSH_THEME_PIJUL_PROMPT_SUFFIX" \
    -v SEPARATOR="$ZSH_THEME_PIJUL_PROMPT_SEPARATOR" \
    -v CHANNEL="$ZSH_THEME_PIJUL_PROMPT_CHANNEL" \
    -v REMOTE_TYPE="$ZSH_PIJUL_PROMPT_SHOW_REMOTE" \
    -v REMOTE_SYMBOL="$ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL" \
    -v REMOTE_NO_TRACKING="$ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING" \
    -v REMOTE_PREFIX="$ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX" \
    -v REMOTE_SUFFIX="$ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX" \
    -v SHOW_LOCAL_COUNTS="$ZSH_PIJUL_PROMPT_SHOW_LOCAL_COUNTS" \
    -v CHANGED="$ZSH_THEME_PIJUL_PROMPT_CHANGED" \
    -v ADDED="$ZSH_THEME_PIJUL_PROMPT_ADDED" \
    -v REMOVED="$ZSH_THEME_PIJUL_PROMPT_REMOVED" \
    -v RESURRECTED="$ZSH_THEME_PIJUL_PROMPT_RESURRECTED" \
    -v SOLVED="$ZSH_THEME_PIJUL_PROMPT_SOLVED" \
    -v UNSOLVED="$ZSH_THEME_PIJUL_PROMPT_UNSOLVED" \
    -v UNTRACKED="$ZSH_THEME_PIJUL_PROMPT_UNTRACKED" \
    -v CLEAN="$ZSH_THEME_PIJUL_PROMPT_CLEAN" \
    -v RC="%{$reset_color%}%b%f%k" \
    -v channel="$channel" \
    -v remote="$remote" \
    '
      BEGIN {
        ORS = ""
        fatal = 0
        changed = 0
        added = 0
        removed = 0
        resurrected = 0
        solved = 0
        unsolved = 0
        untracked = 0
      }

      function status_element(prefix, content, suffix, show_conent) {
        print(prefix)

        # show_count is either 1 or not provided
        if (show_conent == 1 || (show_conent == 0 && show_conent == "")) {
          gsub("%", "%%", content)
          print(content)
        }

        print(suffix)
        print(RC)
      }

      $1 == "fatal:" {
        fatal = 1
      }

      $1 == "MV" || $1 == "M" || $1 == "R" {
        ++changed
      }

      $1 == "A" || $1 == "UD" {
        ++added
      }

      $1 == "A,D" {
        ++added
        ++removed
      }

      $1 == "D" {
        ++removed
      }

      $1 == "RZ" {
        ++resurrected
      }

      $1 == "SC" {
        ++solved
      }

      $1 == "UC" {
        ++unsolved
      }

      $1 == "U" {
        ++untracked
      }

      END {
        if (fatal == 1) {
          exit(1)
        }

        status_element(PREFIX)
        status_element(CHANNEL, channel)

        if (remote == "") {
          status_element(REMOTE_NO_TRACKING)
        } else if (REMOTE_TYPE == "symbol") {
          status_element(REMOTE_SYMBOL)
        } else if (REMOTE_TYPE == "full") {
          status_element(REMOTE_PREFIX, remote, REMOTE_SUFFIX)
        }

        status_element(SEPARATOR)

        if (changed == 0 && added == 0 && removed == 0 && resurrected == 0 && solved == 0 && unsolved == 0 && untracked == 0) {
          status_element(CLEAN)
        } else {
          if (changed > 0) {
            status_element(CHANGED, changed, "", SHOW_LOCAL_COUNTS)
          }

          if (added > 0) {
            status_element(ADDED, added, "", SHOW_LOCAL_COUNTS)
          }

           if (removed > 0) {
            status_element(REMOVED, removed, "", SHOW_LOCAL_COUNTS)
          }

          if (resurrected > 0) {
            status_element(RESURRECTED, resurrected, "", SHOW_LOCAL_COUNTS)
          }

          if (solved > 0) {
            status_element(SOLVED, solved, "", SHOW_LOCAL_COUNTS)
          }

          if (unsolved > 0) {
            status_element(UNSOLVED, unsolved, "", SHOW_LOCAL_COUNTS)
          }

          if (untracked > 0) {
            status_element(UNTRACKED, untracked, "", SHOW_LOCAL_COUNTS)
          }
        }

        status_element(SUFFIX)
      }
    '
}

function _zsh_pijul_prompt_pijul_status_secondary() {
  emulate -L zsh

  local state
  state=$(_zsh_pijul_prompt_pijul_latest_state_cmd | $ZSH_PIJUL_PROMPT_AWK_CMD \
    '$1 == "State:" { print $2 }')

  _zsh_pijul_prompt_pijul_tags_cmd | xargs -L 4 | $ZSH_PIJUL_PROMPT_AWK_CMD \
    -v PREFIX="$ZSH_THEME_PIJUL_PROMPT_SECONDARY_PREFIX" \
    -v SUFFIX="$ZSH_THEME_PIJUL_PROMPT_SECONDARY_SUFFIX" \
    -v SEPARATOR="$ZSH_THEME_PIJUL_PROMPT_TAGS_SEPARATOR" \
    -v TAGS_PREFIX="$ZSH_THEME_PIJUL_PROMPT_TAGS_PREFIX" \
    -v TAGS_SUFFIX="$ZSH_THEME_PIJUL_PROMPT_TAGS_SUFFIX" \
    -v TAG="$ZSH_THEME_PIJUL_PROMPT_TAG" \
    -v RC="%{$reset_color%}%b%f%k" \
    -v state="$state" \
    '
      BEGIN {
        ORS = ""
        fatal = 0
        count = 0
      }

      function status_element(prefix, content, suffix) {
        print(prefix)
        gsub("%", "%%", content)
        print(content)
        print(suffix)
        print(RC)
      }

      func join(array, separator) {
        for (i = 1; i <= count; ++i) {
          print((i > 1 ? separator : "") array[i])
        }
      }

      $1 == "fatal:" {
        fatal = 1
      }

      $2 == state {
        sub(/^State.* UTC /, "", $0)
        tags[++count] = TAG$0
      }

      END {
        if (fatal == 1) {
          exit(1)
        }

        if (count > 0) {
          status_element(PREFIX)
          status_element(TAGS_PREFIX)
          status_element(join(tags, SEPARATOR))
          status_element(TAGS_SUFFIX)
          status_element(SUFFIX)
        }
      }
    '
}

# ASYNC ------------------------------------------------------------------------

# The async code is taken from
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/async.zsh

zmodload zsh/system

function _zsh_pijul_prompt_async_request() {
  typeset -g _ZSH_PIJUL_PROMPT_ASYNC_FD _ZSH_PIJUL_PROMPT_ASYNC_PID

  # If we've got a pending request, cancel it
  if [[ -n "$_ZSH_PIJUL_PROMPT_ASYNC_FD" ]] \
    && { true <&$_ZSH_PIJUL_PROMPT_ASYNC_FD } 2>/dev/null
  then
    # Close the file descriptor and remove the handler
    exec {_ZSH_PIJUL_PROMPT_ASYNC_FD}<&-
    zle -F $_ZSH_PIJUL_PROMPT_ASYNC_FD

    # Zsh will make a new process group for the child process only if job
    # control is enabled (MONITOR option)
    if [[ -o MONITOR ]]
    then
      # Send the signal to the process group to kill any processes that may
      # have been forked by the suggestion strategy
      kill -TERM -$_ZSH_PIJUL_PROMPT_ASYNC_PID 2>/dev/null
    else
      # Kill just the child process since it wasn't placed in a new process
      # group. If the suggestion strategy forked any child processes they may
      # be orphaned and left behind.
      kill -TERM $_ZSH_PIJUL_PROMPT_ASYNC_PID 2>/dev/null
    fi
  fi

  # Fork a process to fetch the pijul status and open a pipe to read from it
  exec {_ZSH_PIJUL_PROMPT_ASYNC_FD}< <(
    # Tell parent process our pid
    builtin echo $sysparams[pid]

    _zsh_pijul_prompt_pijul_status
    [[ -n "$ZSH_PIJUL_PROMPT_ENABLE_SECONDARY" ]] \
      && builtin echo -n "##secondary##" \
      && _zsh_pijul_prompt_pijul_status_secondary
  )

  # There's a weird bug here where ^C stops working unless we force a fork
  # See https://github.com/zsh-users/zsh-autosuggestions/issues/364
  command true

  # Read the pid from the child process
  read _ZSH_PIJUL_PROMPT_ASYNC_PID <&$_ZSH_PIJUL_PROMPT_ASYNC_FD

  # When the fd is readable, call the response handler
  zle -F "$_ZSH_PIJUL_PROMPT_ASYNC_FD" _zsh_pijul_prompt_callback
}

# Called when new data is ready to be read from the pipe
# First arg will be fd ready for reading
# Second arg will be passed in case of error
_ZSH_PIJUL_PROMPT_STATUS_OUTPUT=""
_ZSH_PIJUL_PROMPT_STATUS_SECONDARY_OUTPUT=""

function _zsh_pijul_prompt_callback() {
  emulate -L zsh

  local old_primary="$_ZSH_PIJUL_PROMPT_STATUS_OUTPUT"
  local old_secondary="$_ZSH_PIJUL_PROMPT_STATUS_SECONDARY_OUTPUT"
  local fd_data
  local -a output

  if [[ -z "$2" || "$2" == "hup" ]]
  then
    # Read output from fd
    fd_data="$(cat <&$1)"
    output=( ${(s:##secondary##:)fd_data} )
    _ZSH_PIJUL_PROMPT_STATUS_OUTPUT="${output[1]}"
    _ZSH_PIJUL_PROMPT_STATUS_SECONDARY_OUTPUT="${output[2]}"

    if [[ "$old_primary" != "$_ZSH_PIJUL_PROMPT_STATUS_OUTPUT" ]] || [[ "$old_secondary" != "$_ZSH_PIJUL_PROMPT_STATUS_SECONDARY_OUTPUT" ]]
    then
      zle reset-prompt
      zle -R
    fi

    # Close the fd
    exec {1}<&-
  fi

  # Always remove the handler
  zle -F "$1"

  # Unset global FD variable to prevent closing user created FDs in the precmd hook
  unset _ZSH_PIJUL_PROMPT_ASYNC_FD
}

function _zsh_pijul_prompt_precmd_hook() {
  if [[ -n "$ZSH_PIJUL_PROMPT_FORCE_BLANK" ]]
  then
    _ZSH_PIJUL_PROMPT_STATUS_OUTPUT=""
    _ZSH_PIJUL_PROMPT_STATUS_SECONDARY_OUTPUT=""
  fi

  _zsh_pijul_prompt_async_request
}

# PUBLIC -----------------------------------------------------------------------

if (( $+commands[pijul] ))
then
  if [[ -z "$ZSH_PIJUL_PROMPT_NO_ASYNC" ]]
  then
    # Use the async prompt
    autoload -Uz add-zsh-hook \
      && add-zsh-hook precmd _zsh_pijul_prompt_precmd_hook

    function pijul_prompt() {
      echo -n "$_ZSH_PIJUL_PROMPT_STATUS_OUTPUT"
    }

    function pijul_prompt_secondary() {
      echo -n "$_ZSH_PIJUL_PROMPT_STATUS_SECONDARY_OUTPUT"
    }
  else
    # Use the sync prompt
    function pijul_prompt() {
      _zsh_pijul_prompt_pijul_status
    }

    function pijul_prompt_secondary() {
      [[ -n "$ZSH_PIJUL_PROMPT_ENABLE_SECONDARY" ]] \
        && _zsh_pijul_prompt_pijul_status_secondary
    }
  fi
else
  # Noop if pijul isn't available
  function pijul_prompt() { }
  function pijul_prompt_secondary() { }
fi
