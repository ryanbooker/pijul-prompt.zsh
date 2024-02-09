# MIT License
#
# Copyright © 2024 Ryan Booker
#
# Originally forked (and heavily modified) from git-prompt.zsh
# Copyright © 2023 Wolfgang Popp
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

# Awk
# Find an awk implementation
# Prefer nawk over mawk and mawk over awk
(( $+commands[mawk] )) && : "${ZSH_PIJUL_PROMPT_AWK_CMD:=mawk}"
(( $+commands[nawk] )) && : "${ZSH_PIJUL_PROMPT_AWK_CMD:=nawk}"
                          : "${ZSH_PIJUL_PROMPT_AWK_CMD:=awk}"

# DEFAULT PROMPT ---------------------------------------------------------------

# Disable promptinit if it is loaded
(( $+functions[promptinit] )) && { promptinit; prompt off; }

# Allow parameter and command substitution in the prompt
setopt PROMPT_SUBST

# Override PROMPT if it does not use the pijul_prompt function
[[ "$PROMPT" != *pijul_prompt* && "$RPROMPT" != *pijul_prompt* ]] \
  && PROMPT='%B%40<..<%~ %b$(pijul_prompt)$(pijul_prompt_secondary)' \
  && PROMPT+='%(?.%(!.%F{white}❯%F{yellow}❯%F{red}.%F{blue}❯%F{cyan}❯%F{green})❯.%F{red}❯❯❯)%f ' \
  && RPROMPT=''

# PROMPT GENERATION ------------------------------------------------------------

typeset -g __PIJUL_CHANNEL __PIJUL_REMOTE __PIJUL_STATUS __PIJUL_SECONDARY __PIJUL_FORCE_BLANK

function __exit_unless_pijul_repo() {
  pijul log --limit 1 &>/dev/null
  [[ $? -ne 0 ]] && exit 0
}

function __pijul_prompt() {
  __exit_unless_pijul_repo

  echo -n "$(__pijul_element "$ZSH_THEME_PIJUL_PROMPT_PREFIX")"
  echo -n "$(__pijul_element "$__PIJUL_CHANNEL")"
  echo -n "$(__pijul_element "$__PIJUL_REMOTE")"
  echo -n "$(__pijul_element "$ZSH_THEME_PIJUL_PROMPT_SEPARATOR")"
  echo -n "$(__pijul_element "$__PIJUL_STATUS")"
  echo -n "$(__pijul_element "$ZSH_THEME_PIJUL_PROMPT_SUFFIX")"
}

function __pijul_prompt_secondary() {
  __exit_unless_pijul_repo

  if [[ -n "$ZSH_PIJUL_PROMPT_ENABLE_SECONDARY" ]]; then
    echo -n "$(__pijul_element "$ZSH_THEME_PIJUL_PROMPT_SECONDARY_PREFIX")"
    echo -n "$(__pijul_element "$__PIJUL_SECONDARY")"
    echo -n "$(__pijul_element "$ZSH_THEME_PIJUL_PROMPT_SECONDARY_SUFFIX")"
  fi
}

function __pijul_channel() {
  local element
  element=$(command pijul channel 2>/dev/null | sed -n 's/^\* //p')
  __pijul_element "$ZSH_THEME_PIJUL_PROMPT_CHANNEL" "$element"
}

function __pijul_channel_completion() {
  if [[ "$__PIJUL_CHANNEL" != "$1" ]]; then
    __PIJUL_CHANNEL="$1"
    zle && { zle reset-prompt; zle -R; }
  fi
}

function __pijul_remote() {
  local element
  element=$(command pijul remote 2>/dev/null | sed -En 's/^.*: (.*@)?//p' | head -n 1)

  if [[ -z "$element" ]]; then
    __pijul_element "$ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING"
  elif [[ "$element" == "symbol" ]]; then
    __pijul_element "$ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL"
  elif [[ "$element" == "full" ]]; then
    __pijul_element "$ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX" "$element" "$ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX"
  fi
}

function __pijul_remote_completion() {
  if [[ "$__PIJUL_REMOTE" != "$1" ]]; then
    __PIJUL_REMOTE="$1"
    zle && { zle reset-prompt; zle -R; }
  fi
}

function __pijul_status() {
  command pijul diff --short --untracked 2>/dev/null | $ZSH_PIJUL_PROMPT_AWK_CMD \
  -v SEPARATOR="$ZSH_THEME_PIJUL_PROMPT_SEPARATOR" \
  -v CHANNEL="$ZSH_THEME_PIJUL_PROMPT_CHANNEL" \
  -v SHOW_LOCAL_COUNTS="$ZSH_PIJUL_PROMPT_SHOW_LOCAL_COUNTS" \
  -v CHANGED="$ZSH_THEME_PIJUL_PROMPT_CHANGED" \
  -v ADDED="$ZSH_THEME_PIJUL_PROMPT_ADDED" \
  -v REMOVED="$ZSH_THEME_PIJUL_PROMPT_REMOVED" \
  -v RESURRECTED="$ZSH_THEME_PIJUL_PROMPT_RESURRECTED" \
  -v SOLVED="$ZSH_THEME_PIJUL_PROMPT_SOLVED" \
  -v UNSOLVED="$ZSH_THEME_PIJUL_PROMPT_UNSOLVED" \
  -v UNTRACKED="$ZSH_THEME_PIJUL_PROMPT_UNTRACKED" \
  -v CLEAN="$ZSH_THEME_PIJUL_PROMPT_CLEAN" \
  -v RESET="%{$reset_color%}%b%f%k" \
  '
    BEGIN {
      ORS = ""
      changed = 0
      added = 0
      removed = 0
      resurrected = 0
      solved = 0
      unsolved = 0
      untracked = 0
    }

    function pijul_element(prefix, content, suffix, show_conent) {
      print(prefix)

      # show_count is either 1 or not provided
      if (show_conent == 1 || (show_conent == 0 && show_conent == "")) {
        gsub("%", "%%", content)
        print(content)
      }

      print(suffix)
      print(RESET)
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
      if (changed == 0 && added == 0 && removed == 0 && resurrected == 0 && solved == 0 && unsolved == 0 && untracked == 0) {
        pijul_element(CLEAN)
      } else {
        if (changed > 0) {
          pijul_element(CHANGED, changed, "", SHOW_LOCAL_COUNTS)
        }

        if (added > 0) {
          pijul_element(ADDED, added, "", SHOW_LOCAL_COUNTS)
        }

         if (removed > 0) {
          pijul_element(REMOVED, removed, "", SHOW_LOCAL_COUNTS)
        }

        if (resurrected > 0) {
          pijul_element(RESURRECTED, resurrected, "", SHOW_LOCAL_COUNTS)
        }

        if (solved > 0) {
          pijul_element(SOLVED, solved, "", SHOW_LOCAL_COUNTS)
        }

        if (unsolved > 0) {
          pijul_element(UNSOLVED, unsolved, "", SHOW_LOCAL_COUNTS)
        }

        if (untracked > 0) {
          pijul_element(UNTRACKED, untracked, "", SHOW_LOCAL_COUNTS)
        }
      }
    }
  '
}

function __pijul_status_completion() {
  if [[ "$__PIJUL_STATUS" != "$1" ]]; then
    __PIJUL_STATUS="$1"
    zle && { zle reset-prompt; zle -R; }
  fi
}

function __pijul_secondary() {
  if [[ -n "$ZSH_PIJUL_PROMPT_ENABLE_SECONDARY" ]]; then
    local state
    state=$(command pijul log --state --limit 1 2>/dev/null | $ZSH_PIJUL_PROMPT_AWK_CMD \
      '$1 == "State:" { print $2 }')

    command pijul tag 2>/dev/null | xargs -L 4 | $ZSH_PIJUL_PROMPT_AWK_CMD \
    -v SEPARATOR="$ZSH_THEME_PIJUL_PROMPT_TAGS_SEPARATOR" \
    -v TAGS_PREFIX="$ZSH_THEME_PIJUL_PROMPT_TAGS_PREFIX" \
    -v TAGS_SUFFIX="$ZSH_THEME_PIJUL_PROMPT_TAGS_SUFFIX" \
    -v TAG="$ZSH_THEME_PIJUL_PROMPT_TAG" \
    -v RESET="%{$reset_color%}%b%f%k" \
    -v state="$state" \
    '
      BEGIN {
        ORS = ""
        count = 0
      }

      function status_element(prefix, content, suffix) {
        print(prefix)
        gsub("%", "%%", content)
        print(content)
        print(suffix)
        print(RESET)
      }

      func join(array, separator) {
        for (i = 1; i <= count; ++i) {
          print((i > 1 ? separator : "") array[i])
        }
      }

      $2 == state {
        sub(/^State.* UTC /, "", $0)
        tags[++count] = TAG$0
      }

      END {
        if (count > 0) {
          status_element(TAGS_PREFIX)
          status_element(join(tags, SEPARATOR))
          status_element(TAGS_SUFFIX)
        }
      }
    '
  fi
}

function __pijul_secondary_completion() {
  if [[ "$__PIJUL_SECONDARY" != "$1" ]]; then
    __PIJUL_SECONDARY="$1"
    zle && { zle reset-prompt; zle -R; }
  fi
}

function __pijul_element() {
  echo -n "$1"
  echo -n "$2"
  echo -n "$3"
  echo -n "%{$reset_color%}%b%f%k"
}

# HOOKS ------------------------------------------------------------------------

function __pijul_channel_precmd_hook() {
  if [[ -n "$__PIJUL_FORCE_BLANK" ]]; then
    __PIJUL_CHANNEL=""
  fi

  __async __pijul_channel __pijul_channel_completion
}

function __pijul_remote_precmd_hook() {
  if [[ -n "$__PIJUL_FORCE_BLANK" ]]; then
    __PIJUL_REMOTE=""
  fi

  __async __pijul_remote __pijul_remote_completion
}

function __pijul_status_precmd_hook() {
  if [[ -n "$__PIJUL_FORCE_BLANK" ]]; then
    __PIJUL_STATUS=""
  fi

  __async __pijul_status __pijul_status_completion
}

function __pijul_secondary_precmd_hook() {
  if [[ -n "$__PIJUL_FORCE_BLANK" ]]; then
    __PIJUL_SECONDARY=""
  fi

  __async __pijul_secondary __pijul_secondary_completion
}

function __pijul_chpwd_hook() {
  __PIJUL_CHANNEL=""
  __PIJUL_REMOTE=""
  __PIJUL_STATUS=""
  __PIJUL_SECONDARY=""
}

# ASYNC ------------------------------------------------------------------------

typeset -A __fds __pids __completions

function __async() {
  if [[ -z $1 || -z $2 ]]; then
    echo "ERROR async requires a task to perform and completion handler for the result. e.g. 'async task completion'"
    return 1
  fi

  local task="$1"
  local completion="$2"
  local id="$task-$completion"

  local fd
  local pid

  local running_fd="${__fds[$id]}"
  local running_pid="${__pids[$id]}"

  if [[ -n "$running_fd" ]] && { true <&$running_fd; } 2>/dev/null; then
    exec {running_fd}<&-
    zle -F "$running_fd"

    # Zsh will make a new process group for the child process only if job
    # control is enabled (MONITOR option)
    if [[ -o MONITOR ]]; then
      # Send the signal to the process group to kill any processes that may
      # have been forked by the suggestion strategy
      kill -TERM -$running_pid 2>/dev/null
    else
      # Kill just the child process since it wasn't placed in a new process
      # group. If the suggestion strategy forked any child processes they may
      # be orphaned and left behind.
      kill -TERM $running_pid 2>/dev/null
    fi

    # Cleanup globals
    __cleanup $id
  fi

  exec {fd}< <(
    # Tell parent process our pid
    builtin echo $sysparams[pid]

    # Runt he task
    "$task"
  )

  # There's a weird bug here where ^C stops working unless we force a fork
  # See https://github.com/zsh-users/zsh-autosuggestions/issues/364
  command true

  # Read the pid from the child process
  read pid <&$fd

  __fds[$id]="$fd"
  __pids[$id]="$pid"
  __completions[$id]="$completion"

  # When the fd is readable, call the response handler
  zle -F "$fd" __async_completion
}

function __async_completion() {
  emulate -L zsh

  local fd="$1"
  local id
  local completion

  if [[ -z "$2" || "$2" == "hup" ]]; then
    for key in ${(k)__pids}
    do
      if [[ "$fd" == ${__fds[$key]} ]]; then
        id=$key
        completion=${__completions[$id]}
        break
      fi
    done

    [[ -z $id ]] && return 1

    local result
    result="$(cat <&$fd)"
    $completion "$result"

    # Close the fd
    exec {fd}<&-
  fi

  # Always remove the handler
  zle -F "$fd"

  # Cleanup globals
  __cleanup $id
}

function __cleanup() {
  local id="$1"

  # Unset global variables to prevent closing user created FDs in the precmd hook
  unset "__fds[$id]"
  unset "__pids[$id]"
  unset "__completions[$id]"
}

# PUBLIC -----------------------------------------------------------------------

if (( $+commands[pijul] )); then
  if [[ -z "$ZSH_PIJUL_PROMPT_NO_ASYNC" ]]; then
    # Use the async prompt
    autoload -Uz add-zsh-hook \
      && add-zsh-hook precmd __pijul_remote_precmd_hook \
      && add-zsh-hook precmd __pijul_status_precmd_hook \
      && add-zsh-hook precmd __pijul_secondary_precmd_hook \
      && add-zsh-hook chpwd __pijul_chpwd_hook \

    function pijul_prompt() {
      __PIJUL_CHANNEL=$(__pijul_channel)
      __pijul_prompt
    }

    function pijul_prompt_secondary() {
      __pijul_prompt_secondary
    }
  else
    # Use the sync prompt
    function pijul_prompt() {
      __PIJUL_CHANNEL=$(__pijul_channel)
      __PIJUL_REMOTE=$(__pijul_remote)
      __PIJUL_STATUS=$(__pijul_status)
      __pijul_prompt
    }

    function pijul_prompt_secondary() {
      __PIJUL_SECONDARY=$(__pijul_secondary)
      __pijul_prompt_secondary
    }
  fi
else
  # Noop if pijul isn't available
  function pijul_prompt() { true; }
  function pijul_prompt_secondary() { true; }
fi
