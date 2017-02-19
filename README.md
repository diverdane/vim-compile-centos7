# vim-compile-centos7
Script to compile VIM on CentOS 7, including Lua, Python, and clipboard support.

# Installation
To install, run the following commands:

    git clone https://github.com/diverdane/vim-compile-centos7.git ~/vim-compile-centos7

# Compiling Vim
Run this script with sudo to download and compile Vim:

    sudo ~/vim-compile-centos7/vim-compile.sh

The script will confirm that the compiled Vim supports Lua, Python, and clipboard. If successful, it will then clean up downloaded source code.

# How to uninstall
Do the following:

    sudo ~/vim-compile-centos7/clean-up.sh
    cd
    rm -rf vim-compile-centos7

