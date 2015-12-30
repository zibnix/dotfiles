# http://henrik.nyh.se/2008/12/git-dirty-prompt
# http://www.simplisticcomplexity.com/2008/03/13/show-your-git-branch-name-in-your-prompt/
#   username@Machine ~/dev/dir[master]$   # clean working directory
#   username@Machine ~/dev/dir[master*]$  # dirty working directory

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\]\w \[\033[0;31m\]\$(parse_git_branch)\n:> \[\033[0;33m\]"
PS2=':> '

# Keychain
# Re-use ssh-agent/gpg-agent between logins
# /usr/bin/keychain $HOME/.ssh/id_dsa > /dev/null 2>&1
# source $HOME/.keychain/$HOSTNAME-sh

export EDITOR=vim

alias g=git
alias l="ls -ahl | sort -k 9"
alias v=vim
alias c=clear
alias tm='TERM=screen-256color exec tmux'
alias kon='sudo su root -c "echo 1 >> /sys/class/leds/asus\:\:kbd_backlight/brightness"'
alias koff='sudo su root -c "echo 0 >> /sys/class/leds/asus\:\:kbd_backlight/brightness"'
alias bu="xbacklight +20"
alias bd="xbacklight -20"

# go stuff
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/go/bin

export PATH=$PATH:/sbin:/usr/sbin

# android + java
export JAVA_HOME=/opt/jdk/jdk1.8.0_45
export PATH=$PATH:$HOME/Android/Sdk/tools:$HOME/Android/Sdk/platform-tools
