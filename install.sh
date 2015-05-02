#!/bin/bash

BASEDIR=`dirname $(readlink -f $0)`

function debug {
    echo "[INSTALL] $1"
}

function install_zsh_config {
    debug "Installing zsh configs"

    ZSHDIR=$HOME/.zsh/
    ZSH_PROMPT_DIR=$ZSHDIR/git-prompt
    GIT_PROMPT_REPO=https://github.com/olivierverdier/zsh-git-prompt.git

    mkdir -p $ZSHDIR
    
    if [ ! -d $ZSH_PROMPT_DIR ] 
    then
        debug "Zsh propmpt not found! Fetching it from github"
        git clone $GIT_PROMPT_REPO $ZSH_PROMPT_DIR
    fi

    debug "Linking zsh configs"
    if [ ! -e $ZSHDIR/zshrc_local ]
    then
        ln -s $BASEDIR/zsh/zshrc_local $ZSHDIR/zshrc_local
    fi
    ln -sf $BASEDIR/zsh/zshrc $HOME/.zshrc
}

function install_vim {
    debug "Installing vim config"
    VIM_REPO=https://github.com/nkauppila/dotvim.git

    debug "Fetching vim config from github"
    git clone $VIM_REPO $HOME/.vim
    
    cd $HOME/.vim
    debug "Initializing submodules"
    git submodule init
    git submodule update

    debug "Linking vim config"
    ln -sf ~/.vim/vimrc ~/.vimrc
}

function pull_git_repo {
    if [ ! -d $1 ]
    then
        debug "Dir $1 does not exists!"
    else
        pushd $1 > /dev/null
        if [ -d .git ]
        then
            git pull
        fi
        popd > /dev/null
    fi
}

function usage {
    echo "$0 [update] [install]"
}

function install {
    install_zsh_config

    if [ ! -d $HOME/.vim ]
    then
        install_vim
    fi

    debug "Dont forget to source $HOME/.zshrc"
}

function update {
    debug "Updating configs"
    pull_git_repo $BASEDIR

    debug "Updating vim"
    pull_git_repo $HOME/.vim
}

if [ $# -ne 1 ]
then
    usage
    exit 1
fi

case $1 in
    update)
        update
        ;;
    install)
        install
        ;;
    *)
        usage
        exit 2
        ;;
esac
exit 1
