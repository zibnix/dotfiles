#!/usr/bin/env bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables
apt=false
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc zshrc vim vimrc gitconfig gitignore tmux.conf"    # list of files/folders to symlink in homedir

##########

until [ -z "$1" ]; do
    case "$1" in
        -apt) apt=true; shift ;;
        *) echo "invalid option $1" 1>&2 ; shift ;;
    esac
done

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    mv ~/.$file $olddir/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# prepare the submodules
git submodule update --init --recursive

if "$apt" ; then
    # apt-get install a bunch of stuff, lib32stdc++6 required by android studio
    # sudo cp sources.list /etc/apt/sources.list &&
    sudo apt-get update &&
    cat packages | sudo xargs apt-get -y install &&
    dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal.dconf
fi
