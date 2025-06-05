#!/bin/bash

cd ~/git/vim-config || exit 1

# Copy the config files
cp ~/.vimrc ./vimrc
rsync -a --delete ~/.vim/ ./vimdir/

# Stage changes
git add .

# Commit only if there are changes
if ! git diff --cached --quiet; then
    git commit -m "Auto backup on $(date)"
    git push
fi

