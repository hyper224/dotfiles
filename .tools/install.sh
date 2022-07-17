#!/usr/bin/env sh

# Reference
# https://www.atlassian.com/git/tutorials/dotfiles
# https://news.ycombinator.com/item?id=11070797
# https://github.com/Siilwyn/my-dotfiles/tree/master/.my-dotfiles

# setup
# git init --bare $HOME/dotfiles
# alias config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
# config remote add origin https://github.com/hyper224/dotfiles.git

# replication
git clone --separate-git-dir=$HOME/dotfiles https://github.com/hyper224/dotfiles.git dotfiles-tmp
rsync --recursive --verbose --exclude '.git' dotfiles-tmp/ $HOME/
rm --recursive --force dotfiles-tmp

git --git-dir=$HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# configuration
# config config --local status.showUntrackedFiles no
# config push --set-upstream origin main

# usage
# config status
# config add .gitconfig
# config commit -m 'Add gitconfig'
# config push

. "$HOME/.tools/create_videoclip_dir"
. "$HOME/.tools/setup.sh"
