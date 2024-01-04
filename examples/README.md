# git-prompt.zsh examples
You can test the [configurations shown below](#examples) by sourcing the `.zsh` files from the examples directory.

Once you have found a configuration that you like, source it in your `.zshrc`.

## Preview all examples directly in Zsh

```
pijul clone https://nest.pijul.com/ryanbooker/pijul-prompt.zsh
cd pijul-prompt.zsh

examples/print_examples.sh
```

## Examples

<!-- truncate here before generating examples -->

### Ascii
A prompt using only ASCII characters.

Load this example: `source examples/ascii.zsh`

```
..pace/hello_world main +1-1..3>
```

### [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt) clone

This example mimics the [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt)
informative git prompt for bash.

Load this example: `source examples/bashgitprompt.zsh`

```
~/workspace/hello_world [main ⟳ |+1−1…3]
20:46 $
```

### Compact

Load this example: `source examples/compact.zsh`

```
..space/hello_world main|+1−1…3❯
```

### Default

Same as shown in [screenshot.svg](../screenshot.svg).

Load this example: `source examples/default.zsh`

```
../hello_world [main|+1−1…3] ❯❯❯
```

### Multi-line

Load this example: `source examples/multiline.zsh`

```
┏╸~/workspace/hello_world · ⎇ main ⤳ /pijul-prompt.zsh ‹+1−1…3›
┗╸❯❯❯
```

### [Pure](https://github.com/sindresorhus/pure) clone

This clone of the Pure prompt has support for Python virtualenvs, but none of the timing
features or a vi mode. If you are using [fzf](https://github.com/junegunn/fzf), source the
example after sourcing fzf's keybindings.

If you want to try other examples again after sourcing the Pure example, you might have to
restart your shell, because this prompt will always print a newline between prompts.

Load this example: `source examples/pure.zsh`

```
~/workspace/hello_world main +1−1…3
❯
```

### Git status on the right

Load this example: `source examples/rprompt.zsh`

```
~/workspace/hello_world ≻≻≻        [main|+1−1…3]
```

### Woefe's prompt (wprompt)

The wprompt example is similar to the multi-line and Pure examples, but with optional
[vi-mode](https://github.com/woefe/vi-mode.zsh) and the secondary prompt enabled.

- Depends on [Font Awesome](https://fontawesome.com/)
- Optionally depends on [vi-mode](https://github.com/woefe/vi-mode.zsh)
- Source this example after fzf and after loading
[vi-mode](https://github.com/woefe/vi-mode.zsh)

If you want to try other examples again after sourcing this example, you might have to restart
your shell, because this prompt will always print a newline between prompts.

Load this example: `source examples/wprompt.zsh`

```
┏╸~/workspace/hello_world · ⎇ main! · +1−1…3
┗╸❯❯❯
```

### Wry

Load this example: `source examples/wry.zsh`

```
~/workspace/hello_world .. main > /pijul-prompt.zsh +1−1…3          ●```
