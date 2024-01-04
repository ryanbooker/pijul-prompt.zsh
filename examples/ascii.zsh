# Name: Ascii
# Description: A prompt using only ASCII characters.

ZSH_THEME_PIJUL_PROMPT_PREFIX=" "
ZSH_THEME_PIJUL_PROMPT_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_SEPARATOR=" "
ZSH_THEME_PIJUL_PROMPT_CHANNEL="%{$fg_bold[magenta]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL="%{$fg_bold[yellow]%}^"
ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX="%{$fg[red]%})"
ZSH_THEME_PIJUL_PROMPT_CHANGED="%{$fg[blue]%}o"
ZSH_THEME_PIJUL_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_PIJUL_PROMPT_REMOVED="%{$fg[red]%}-"
ZSH_THEME_PIJUL_PROMPT_SOLVED="%{$fg[magenta]%}&"
ZSH_THEME_PIJUL_PROMPT_UNSOLVED="%{$fg[yellow]%}?"
ZSH_THEME_PIJUL_PROMPT_UNTRACKED=".."
ZSH_THEME_PIJUL_PROMPT_CLEAN="%{$fg_bold[green]%}>"

PROMPT='%B%40<..<%~%b$(pijul_prompt)'
PROMPT+='%(?.%(!.%F{yellow}.%F{green})>%f.%F{red}>%f) '
RPROMPT=''
