#!/usr/bin/env bash

# my prefered directory structure
build_dir(){
    mkdir -p "${HOME}/Libraries"
    mkdir -p "${HOME}/Miscellaneous"
}

# system
build_sys(){
    sudo apt update

    # default build-related tools
    sudo apt install git build-essential
    sudo apt install python-dev python3-dev
    sudo apt install checkinstall
    sudo apt install cmake-qt-gui
    sudo apt install ccache

    # misc (but important?)
    sudo apt install openssh-client openssh-server
    sudo apt install dtrx # unified decompression interface 
    sudo apt install screen
    sudo apt install ncdu
    sudo apt install htop
    # TODO : add other things if they come up
}

# vim
build_vim(){
    # build vim from source
    mkdir -p "${HOME}/Libraries"
    pushd "${HOME}/Libraries"
    sudo apt install ncurses-dev
    git clone https://github.com/vim/vim.git
    cd vim
    ./configure --with-features=huge \
        --enable-pythoninterp=no \
        --with-python-config-dir='/usr/lib/x86_64-linux-gnu/python2.7/config' \
        --enable-python3interp=yes \
        --with-python3-config-dir='/usr/lib/x86_64-linux-gnu/python3.5/config' \
        --enable-gui=auto \
        --enable-cscope \
        --enable-terminal \
	--with-x
    make -j8 VIMRUNTIMEDIR=/usr/local/share/vim/vim81
    sudo checkinstall 
    sudo update-alternatives --install /usr/local/bin/vim vim /usr/bin/vim 100
    popd

    # vundle - plugins
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    # youcompleteme : follow-up steps
    # may require the following steps:
    # sudo pip2 install --upgrade pyopenssl
    # sudo python -m easy_install --upgrade pyOpenSSL
    ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
}

build(){
    build_sys
    build_vim
}
