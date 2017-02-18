# vim-compile-centos7
Script to compile VIM on CentOS 7, including Lua, Python, and clipboard support.

# Installation Instructions
To install, run the following commands:

    git clone https://github.com/diverdane/vim-compile-centos7.git ~/vim-compile

Optionally, copy the script to your bin directory:

    mkdir -p ~/bin
    cp ~/vim-compile/vim-compile.sh ~/bin

# Running the script

    ~/vim-compile/vim-compile.sh

The script will confirm that the compiled Vim supports Lua and Python.

# How to uninstall
Do the following:
* Remove `~/vim-compile-centos7`
* Remove any copies of vim-compile.sh from your ~/bin

