#!/usr/bin/env bash

tmpdir=$(mktemp -d -p /tmp pijul-prompt.zsh.XXXX)
projectdir=$(dirname "$(dirname "$(realpath "$0")")")
trap 'rm -rf -- "$tmpdir"' EXIT
mkdir -p "$tmpdir/workspace"

pijul clone $projectdir --path "examples/hello-world" "$tmpdir/workspace/hello_world"
cd "$tmpdir/workspace/hello_world" || exit
export HOME=$tmpdir

pijul identity new --no-link --no-prompt --display-name "Bob" --email "bob@example.com" --username "bob" "pijul-prompt.zsh"

echo "Hi!" >> README.md

touch removed.txt
pijul add removed.txt
pijul record -a -m "Add removed.txt"
pijul remove removed.txt

touch added.txt
pijul add added.txt

if [[ $1 = "--readme" ]]; then
    for example in "$projectdir"/examples/*.zsh; do
        heading=$(sed -n '/^# Name: /p' "$example")
        heading=${heading##\# Name: }

        description=$(sed -En '/^# Description:/,/(^# [^ ]|^$)/p' "$example")
        description=${description##\# Description:}
        description=$(echo "$description" | sed -E 's/^#? *//')

        echo "### $heading"
        echo "$description"
        echo
        echo "Load this example: \`source ${example##"$projectdir"/}\`"
        echo
        echo '```'
        zsh -f -c "export ZSH_PIJUL_PROMPT_NO_ASYNC=1; source \"$projectdir/pijul-prompt.zsh\"; source \"$example\"; print -P \"\$PROMPT       \$RPROMPT\"" 2> /dev/null | sed 's/\x1B\[[0-9;]*[JKmsu]//g'
        echo '```'
        echo
        echo
    done
    exit
fi


for example in "$projectdir"/examples/*.zsh; do
    echo "${example##"$projectdir"/}:"
    zsh -f -c "export ZSH_PIJUL_PROMPT_NO_ASYNC=1; source \"$projectdir/pijul-prompt.zsh\"; source \"$example\"; print -P \"\$PROMPT       \$RPROMPT\"" 2> /dev/null
    echo
    echo
done
