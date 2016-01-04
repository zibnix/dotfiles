#!/usr/bin/env bash

curltime () {
    curl -o /dev/null -D - -w 'appconn: %{time_appconnect}\nconnect: %{time_connect}\ndnslook: %{time_namelookup}\npretran: %{time_pretransfer}\nredirec: %{time_redirect}\nstarttr: %{time_starttransfer}\n  TOTAL: %{time_total}\n' $1
}

b642hex () {
    echo $1 | base64 --decode | xxd -c 256 -p
}

xfcpy () {
    cat $1 | xclip -selection clipboard
}

xfpst () {
    xclip -selection clipboard -o > $1
}

# a function for setting up Go, pass a git tagname to specify Go's version
install_go() {
    default='go1.5.2'

    ver="$1"
    if [ -z "$ver" ]; then
        ver="$default"
    fi

    # go1.4 is required to compile the compilers/assemblers/linkers for >=go1.5
    mkdir ~/go1.4temp

    tarfile='go1.4.3.linux-amd64.tar.gz'
    curl https://storage.googleapis.com/golang/"$tarfile" > "$tarfile" &&
    tar -C ~/go1.4temp -xzf "$tarfile" &&
    mv ~/go1.4temp/go ~/go1.4 && rm -rf ~/go1.4temp && rm "$tarfile"

    # clone Go repo
    git clone https://go.googlesource.com/go ~/go &&
    # checkout latest release
    cd ~/go && git checkout "$ver" &&
    # install
    cd ~/go/src && ./all.bash 
    # gopath dir
    mkdir ~/gocode
}

# a function for compiling & installing YouCompleteMe
install_ycm() {
    cd ~/.vim/bundle/YouCompleteMe &&
    PATH=$PATH:$HOME/go/bin ./install.py --clang-completer --gocode-completer
}

# a function for setting up a /mnt/tmpfs, pass a size: $ make_tmpfs 2G
make_tmpfs() {
    default='2G'

    sz="$1"
    if [ -z "$sz" ]; then
        sz="$default"
    fi

    sudo mkdir /mnt/tmpfs
    sudo mount -o size="$sz" -t tmpfs tmpfs /mnt/tmpfs
}
