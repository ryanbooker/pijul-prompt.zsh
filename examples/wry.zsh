# Name: Wry
# Description: The prompt I prefer.

ZSH_PIJUL_PROMPT_ENABLE_SECONDARY=1
ZSH_PIJUL_PROMPT_SHOW_REMOTE=1

ZSH_THEME_PIJUL_PROMPT_PREFIX="%{$fg_bold[yellow]%}.. "
ZSH_THEME_PIJUL_PROMPT_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_SEPARATOR=" "
ZSH_THEME_PIJUL_PROMPT_CHANNEL="%{$fg_bold[yellow]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL=""
ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING="%{$fg_bold[yellow]%}⌃"
ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX="%{$fg_bold[yellow]%} > "
ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_CHANGED="%{$fg[magenta]%}∆"
ZSH_THEME_PIJUL_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_PIJUL_PROMPT_REMOVED="%{$fg[red]%}−"
ZSH_THEME_PIJUL_PROMPT_RESURRECTED="%{$fg[grey]%}✝"
ZSH_THEME_PIJUL_PROMPT_SOLVED="%{$fg[green]%}⛙"
ZSH_THEME_PIJUL_PROMPT_UNSOLVED="%{$fg[red]%}×"
ZSH_THEME_PIJUL_PROMPT_UNTRACKED="%{$fg[yellow]%}…"
ZSH_THEME_PIJUL_PROMPT_CLEAN="%{$fg_bold[green]%}✔"
ZSH_THEME_PIJUL_PROMPT_SECONDARY_PREFIX=" "
ZSH_THEME_PIJUL_PROMPT_SECONDARY_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_TAGS_SEPARATOR=" "
ZSH_THEME_PIJUL_PROMPT_TAGS_PREFIX=""
ZSH_THEME_PIJUL_PROMPT_TAGS_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_TAG="#"

PROMPT=$'\n'
[ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ] \
  && PROMPT+='%B%F{blue}@%m%f%b: '  # Hostname, if in SSH session
PROMPT+='%B%F{blue}%~%f%b '         # Path
PROMPT+='$(pijul_prompt)'           # Pijul status
PROMPT+='$(pijul_prompt_secondary)' # Pijul status secondary info
PROMPT+=$'\n'                       # Newline

# Last command status indicator
RPROMPT='%(?.%(!.%F{yellow}●%f.%F{green}●%f).%F{red}●%f)'
