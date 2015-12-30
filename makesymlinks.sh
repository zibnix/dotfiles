#!/usr/bin/env bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables
apt=false
ycm=false
go=false
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc zshrc vim vimrc gitconfig gitignore"    # list of files/folders to symlink in homedir

##########

until [ -z "$1" ]; do
    case "$1" in
        -apt) apt=true; shift ;;
        -go) go=true; shift ;;
        -ycm) ycm=true; shift ;;
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

# xchat colors
cp --parents ./.xchat2/colors.conf ~

if "$apt" ; then
    # apt-get install a bunch of stuff, lib32stdc++6 required by android studio
    sudo apt-get update &&
    cat packages | sudo xargs apt-get -y install
fi
 
if "$go" ; then
    # go1.4 is required to compile the compilers/assemblers/linkers for >=go1.5
    mkdir ~/go1.4temp

    tarfile='go1.4.3.linux-amd64.tar.gz'
    curl https://storage.googleapis.com/golang/"$tarfile" > "$tarfile" &&
    tar -C ~/go1.4temp -xzf go1.4.3.linux-amd64.tar.gz &&
    mv ~/go1.4temp/go ~/go1.4 && rm -rf ~/go1.4temp && rm "$tarfile"

    # clone Go repo
    git clone https://go.googlesource.com/go ~/go &&
    # checkout latest release
    cd ~/go && git checkout $(git describe --tags `git rev-list --tags --max-count=1`) &&
    # install
    cd ~/go/src && ./all.bash 
    # gopath dir
    mkdir ~/gocode
fi

if "$ycm" ; then
    # compile and install YouCompleteMe
    cd ~/.vim/bundle/YouCompleteMe &&
    PATH=$PATH:$HOME/go/bin ./install.py --clang-completer --gocode-completer
fi
