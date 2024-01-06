# Pijul Prompt

A fast, customisable, pure-shell, asynchronous Pijul prompt for Zsh.

It is heavily inspired by and essentially a fork of Wolfgang Popp's [git-prompt.zsh](https://github.com/woefe/git-prompt.zsh) with the Awk parser updated for Pijul. In turn, [git-prompt.zsh](https://github.com/woefe/git-prompt.zsh) is heavily inspired by Olivier Verdier's [zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt) and very similar to the "Informative VCS" prompt of fish shell.

Most of the credit should go to them 🙏.

## Prompt Structure

The structure of the prompt (in the default configuration) is the following:

```
[<channel><remote>|<local_status>]
```

* `channel`: Name of the current channel.
* `remote`: Path of the remote if it exists.
    Must be enabled explicitly (see [Enable remote info](#enable-remote-info)).
* `local_status`:
    * `✔`: repository is clean
    * `∆n`: there are `n` changed files
    * `+n`: there are `n` added files
    * `−n`: there are `n` deleted files
    * `✝n`: there are `n` resurrected zombies
    * `⛙n`: there are `n` solved conflicts
    * `×n`: there are `n` unsolved conflicts
    * `…n`: there are `n` untracked files

## Installation

### Dependencies

* [pijul](pijul.org)
* [awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html), which is most certainly preinstalled on any \*nix system.

### Manual installation

Clone this repo or download the [pijul-prompt.zsh](https://nest.pijul.com/ryanbooker/pijul-prompt) file. Then source it in your `.zshrc`. For example:

```bash
mkdir -p ~/.zsh
pijul clone https://nest.pijul.com/ryanbooker/pijul-prompt.zsh ~/.zsh/pijul-prompt.zsh
echo "source ~/.zsh/pijul-prompt.zsh/pijul-prompt.zsh" >> .zshrc

# Optional: install an example configuration
echo "source ~/.zsh/pijul-prompt.zsh/examples/default.zsh" >> .zshrc
```

### [Zplug](https://github.com/zplug/zplug)

Either install the default prompt (see [Examples](#examples) section below) with
```
# Installs the "default" example
zplug "ryanbooker/pijul-prompt.zsh"
```
or choose an example prompt with
```
# Installs the "multiline" example
zplug "ryanbooker/pijul-prompt.zsh", use:"{pijul-prompt.zsh,examples/default.zsh}"
```

### [Zplugin](https://github.com/zdharma/zplugin)

```
zplugin ice atload'!_zsh_pijul_prompt_precmd_hook' lucid
zplugin load ryanbooker/pijul-prompt.zsh
```
Note that this method does not work if you want to disable the asynchronous rendering.

## Customization

Unlike other popular prompts this prompt does not use `promptinit`, which gives you the flexibility to build your own prompt from scratch. You can build a custom prompt by setting the `PROMPT` variable in your `.zshrc` after souring the `pijul-prompt.zsh`. And you should use `'$(pijul_prompt)'` in your `PROMPT` to get the Prijul prompt. You must set your `PROMPT` with **single quotes**, not double quotes, otherwise the Pijul prompt will not update properly. Some example `PROMPT` configurations are given below. You can find more information on how to configure the `PROMPT` in [Zsh's online documentation](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html) or the `zshmisc` manpage, section "SIMPLE PROMPT ESCAPES".

### Examples

See [examples/README.md](./examples/README.md) for more details.

### Appearance
The appearance of the prompt can be adjusted by changing the variables that start with `ZSH_THEME_PIJUL_PROMPT_`.

You can preview your configuration by setting the `ZSH_THEME_PIJUL_PROMPT_*` variables in a running shell. But remember to save them in your `.zshrc` after you tweaked them to your liking!
Example snippet from `.zshrc`:

```zsh
ZSH_THEME_PIJUL_PROMPT_PREFIX="["
ZSH_THEME_PIJUL_PROMPT_SUFFIX="] "
ZSH_THEME_PIJUL_PROMPT_SEPARATOR="|"
ZSH_THEME_PIJUL_PROMPT_CHANNEL="%{$fg_bold[magenta]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING=""
ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX="%{$fg[red]%})"
ZSH_THEME_PIJUL_PROMPT_CHANGED="%{$fg[blue]%}∆"
ZSH_THEME_PIJUL_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_PIJUL_PROMPT_REMOVED="%{$fg[red]%}−"
ZSH_THEME_PIJUL_PROMPT_RESURRECTED="✝"
ZSH_THEME_PIJUL_PROMPT_SOLVED="%{$fg[magenta]%}⛙"
ZSH_THEME_PIJUL_PROMPT_UNSOLVED="%{$fg[yellow]%}×"
ZSH_THEME_PIJUL_PROMPT_UNTRACKED="…"
ZSH_THEME_PIJUL_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

source path/to/pijul-prompt.zsh
```

### Enable remote info

The prompt will show information about the remote, if `ZSH_PIJUL_PROMPT_SHOW_REMOTE` is set to `full` or `symbol`. The `full` option will print the full remote path enclosed by `ZSH_THEME_PIJUL_PROMPT_REMOTE_PREFIX` and `ZSH_THEME_PIJUL_PROMPT_REMOTE_SUFFIX`. The `symbol` option prints only `ZSH_THEME_PIJUL_PROMPT_REMOTE_SYMBOL`.

Furthermore, a warning symbol can be configured through `ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING` for the case where no remote is available. `ZSH_THEME_PIJUL_PROMPT_REMOTE_NO_TRACKING` can be set independently of `ZSH_PIJUL_PROMPT_SHOW_REMOTE`.

### Disable display of numbers

By default, the prompt will show counts for each item in the tracking status and local status sections. (See [Prompt Structure](#prompt-structure) for details about these sections.) However, you can disable the display of counts for either or both sections of the prompt using `ZSH_PIJUL_PROMPT_SHOW_TRACKING_COUNTS` and `ZSH_PIJUL_PROMPT_SHOW_LOCAL_COUNTS`. If you set these variables to anything other than `1`, then the symbols will be shown but not the counts.
For example, a prompt such as `[master|✚2]` will become `[master|✚]` instead.

### Force blank

Since the prompt is asynchronous by default, the Pijul status updates slightly delayed.
This has the benefit that the prompt will always be responsive even if the repository is huge and/or your disk is slow. But it also means that the old status will be displayed for some time. You can force the prompt to blank out instead of displaying a potentially outdated status, but be warned that this will probably increase flickering. Set the following variable in your `.zshrc` to enable this behavior:

```bash
ZSH_PIJUL_PROMPT_FORCE_BLANK=1
```

### Disable async

If you are not happy with the asynchronous behavior, you can disable it altogether. But be warned that this can make your shell painfully slow if you enter large repositories or if your disk is slow. Set the following variable in your `.zshrc` **before** sourcing the `pijul-prompt.zsh` to enable this behavior.

```bash
ZSH_PIJUL_PROMPT_NO_ASYNC=1
```
`ZSH_PIJUL_PROMPT_NO_ASYNC` cannot be adjusted in a running shell, but only in your `.zshrc`.

### Change the awk implementation

Some awk implementations are faster than others. By default, the prompt checks for [nawk](https://github.com/onetrueawk/awk) and then [mawk](https://invisible-island.net/mawk/) and then falls back to the system's default awk. You can override this behavior by setting `ZSH_PIJUL_PROMPT_AWK_CMD` to the awk implementation of you liking **before** sourcing the `pijul-prompt.zsh`. `ZSH_PIJUL_PROMPT_AWK_CMD` cannot be adjusted in a running shell, but only in your `.zshrc`.

To benchmark an awk implementation you can use the following command.

```bash
# This example tests the default awk. You should change it to something else.
time ZSH_PIJUL_PROMPT_AWK_CMD=awk zsh -f -c '
    source path/to/pijul-prompt.zsh
    for i in $(seq 1000); do
        print -P $(_zsh_pijul_prompt_pijul_status)
    done'
```

## Features / Non-Features

* A pure shell implementation using [awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html); no Python, no Haskell required
    <!-- Well, technically awk is its own programming language and therefore not "pure shell", but heh -->
* Only the Pijul status; This prompt basically only gives you the `pijul_prompt` function, which you can use to build your own prompt.
* Fast; Pijul commands are invoked as few times as possible and asynchronously when a new prompt is drawn.

## Known issues

* If the current working directory is not a Pijul repository and some external application initializes a new repository in the same directory, the Pijul prompt will not be shown immediately. Also, updates made by external programs or another shell do not show up immediately. Executing any command or simply pressing enter to draw a new prompt will fix the issue.
* In large repositories the prompt might slow down, because Pijul has to do whatever it has to do.
