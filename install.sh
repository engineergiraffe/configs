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

install_zsh_config

if [ ! -d $HOME/.vim ]
then
    install_vim
fi

debug "Dont forget to source $HOME/.zshrc"
