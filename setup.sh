#!/usr/bin/env bash

function list-dotfiles(){
    #find . -maxdepth 1 -type f -name '\.*' -exec sh -c '
    #for f do
    #    git check-ignore -q "$f" || echo $f
    #done
    #' find-sh {} +
    echo ".bashrc"
    echo ".vimrc"
    echo ".inputrc"
    echo ".python_startup.py"
}

for src in $(list-dotfiles); do
    dst="$HOME/$(basename $src)"
    if [ -f "$dst" ]; then
	cp "$dst" "$dst.bak"
        rm -i "$dst"
    fi
    ln -sv "$(realpath $src)" "$dst"
done
