# Name: Woefe's prompt (wprompt)
# Description:
#  The wprompt example is similar to the multi-line and Pure examples, but with optional
#  [vi-mode](https://github.com/woefe/vi-mode.zsh) and the secondary prompt enabled.
#
#  - Depends on [Font Awesome](https://fontawesome.com/)
#  - Optionally depends on [vi-mode](https://github.com/woefe/vi-mode.zsh)
#  - Source this example after fzf and after loading
#    [vi-mode](https://github.com/woefe/vi-mode.zsh)
#
#  If you want to try other examples again after sourcing this example, you might have to restart
#  your shell, because this prompt will always print a newline between prompts.

ZSH_PIJUL_PROMPT_FORCE_BLANK=1

ZSH_THEME_PIJUL_PROMPT_PREFIX=" · "
ZSH_THEME_PIJUL_PROMPT_SUFFIX=""
ZSH_THEME_PIJUL_PROMPT_SEPARATOR=" · "
ZSH_THEME_PIJUL_PROMPT_CHANNEL="⎇ %{$fg_bold[cyan]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL="%{$fg_bold[green]%} "
ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING="%{$fg_bold[red]%}!"
ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX="%{$fg[red]%})"
ZSH_THEME_PIJUL_PROMPT_CHANGED="%{$fg[blue]%}∆"
ZSH_THEME_PIJUL_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_PIJUL_PROMPT_REMOVED="%{$fg[red]%}−"
ZSH_THEME_PIJUL_PROMPT_RESURRECTED="✝"
ZSH_THEME_PIJUL_PROMPT_SOLVED="%{$fg[magenta]%}⛙"
ZSH_THEME_PIJUL_PROMPT_UNSOLVED="%{$fg[yellow]%}×"
ZSH_THEME_PIJUL_PROMPT_UNTRACKED="…"
ZSH_THEME_PIJUL_PROMPT_CLEAN="%{$fg_bold[green]%} "
ZSH_THEME_PIJUL_PROMPT_TAGS_PREFIX=" ·  "

RPROMPT=''
PROMPT=$'┏╸'
[ -n "$SSH_CLIENT" ] \
    && [ -n "$SSH_TTY" ] \
    && PROMPT+='%B%F{blue}@%m%f%b · '  # Hostname, if in SSH session
PROMPT+='%B%30<..<%~%b%<<'             # Path truncated to 30 characters
PROMPT+='%(12V. · %F{244} %12v%f.)'  # Python virtualenv name
PROMPT+='$(pijul_prompt)'              # Pijul status
PROMPT+='$(pijul_prompt_secondary)'    # Pijul status secondary info
PROMPT+=$'\n┗╸'                        # Newline

_WPROMPT_END='%(?.%(!.%F{white}❯%F{yellow}❯%F{red}.%F{blue}❯%F{cyan}❯%F{green})❯%f.%F{red}❯❯❯%f) '
# Vi mode indicator, if github.com/woefe/vi-mode.zsh is loaded
if (( $+functions[vi_mode_status] )); then
    VI_INSERT_MODE_INDICATOR=$_WPROMPT_END
    VI_NORMAL_MODE_INDICATOR=${_WPROMPT_END//❯/•}

    PROMPT+='$(vi_mode_status)'
else
    PROMPT+=$_WPROMPT_END
fi

setup() {
    [[ -n $_PROMPT_INITIALIZED ]] && return
    _PROMPT_INITIALIZED=1

    # Prevent Python virtualenv from modifying the prompt
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    # Set $psvar[12] to the current Python virtualenv
    function _prompt_update_venv() {
        psvar[12]=
        if [[ -n $VIRTUAL_ENV ]] && [[ -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
            psvar[12]="${VIRTUAL_ENV:t}"
        fi
    }
    add-zsh-hook precmd _prompt_update_venv

    # Draw a newline between every prompt
    function _prompt_newline(){
        if [[ -z "$_PROMPT_NEWLINE" ]]; then
            _PROMPT_NEWLINE=1
        elif [[ -n "$_PROMPT_NEWLINE" ]]; then
            echo
        fi
    }
    add-zsh-hook precmd _prompt_newline

    # To avoid glitching with fzf's alt+c binding we override the fzf-redraw-prompt widget.
    # The widget by default reruns all precmd hooks, which prints the newline again.
    # We therefore run all precmd hooks except _prompt_newline.
    function fzf-redraw-prompt() {
        local precmd
        for precmd in ${precmd_functions:#_prompt_newline}; do
            $precmd
        done
        zle reset-prompt
    }
}
setup
