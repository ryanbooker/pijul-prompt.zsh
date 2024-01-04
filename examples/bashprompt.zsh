# Name: [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt) clone
# Description:
#  This example mimics the [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt)
#  informative git prompt for bash.

ZSH_PIJUL_PROMPT_SHOW_REMOTE="symbol"
ZSH_PIJUL_PROMPT_FORCE_BLANK=1

ZSH_THEME_PIJUL_PROMPT_PREFIX="%B %b["
ZSH_THEME_PIJUL_PROMPT_SUFFIX="]"
ZSH_THEME_PIJUL_PROMPT_SEPARATOR="|"
ZSH_THEME_PIJUL_PROMPT_CHANNEL="%{$fg[magenta]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL=" %{$fg_bold[yellow]%}⟳ "
ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX="%{$fg[yellow]%} ⤳ "
ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_CHANGED="%{$fg[blue]%}∆"
ZSH_THEME_PIJUL_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_PIJUL_PROMPT_REMOVED="%{$fg[red]%}−"
ZSH_THEME_PIJUL_PROMPT_RESURRECTED="✝"
ZSH_THEME_PIJUL_PROMPT_SOLVED="%{$fg[magenta]%}⛙"
ZSH_THEME_PIJUL_PROMPT_UNSOLVED="%{$fg[yellow]%}×"
ZSH_THEME_PIJUL_PROMPT_UNTRACKED="…"
ZSH_THEME_PIJUL_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

PROMPT=$'%(?..%F{red}%?%f · )%F{yellow}%B%~%b%F{white}$(pijul_prompt)\n%D{%H:%M} $ '
RPROMPT=''
