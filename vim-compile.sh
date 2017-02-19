#!/bin/bash

#
# Script to compile Vim with Lua, Python, and clipboard support on CentOS7
#
# MAKE SURE TO RUN THIS SCRIPT WITH sudo, e.g.:
#      sudo ./vim-compile.sh
#

# Exit on error
set -e

# Create a local repo directory, and then a local repo using that directory
REPO_DIR="/var/lib/yum/repos/x86_65/7/local"
mkdir -p $REPO_DIR
createrepo $REPO_DIR
yum groups mark convert

# Create 'Development tools' install group
yum groupinstall -y 'Development tools'

# Install ncurses, Lua and Python developers' package
yum install ncurses ncurses-devel
yum install lua-devel
yum install python-devel

# Install X11 Development tools for clipboard support
yum install libX11-devel libXtst-devel libXt-devel
yum install libXpm-devel libSM-devel

# Get the latest version of the Vim source code, unpack it
SRC_DIR=/usr/local/src
TAR_FILE=vim-7.4.tar.bz2
VIM_DIR=$SRC_DIR/vim74
cd $SRC_DIR
if ! wget ftp://ftp.vim.org/pub/vim/unix/$TAR_FILE ; then
    echo "ERROR: wget command failed. If you are behind a firewall,"
    echo "try adding an ftp_proxy setting in /etc/wgetrc"
    exit 1
fi
tar -xjf $TAR_FILE

# Configure the build along with any options we want to add
cd $VIM_DIR
./configure --prefix=/usr \
                 --with-features=huge \
                 --enable-largefile \
                 --enable-pythoninterp \
                 --with-python-config-dir=/usr/lib64/python2.7/config \
                 --enable-gui=auto \
                 --enable-fail-if-missing \
                 --enable-luainterp \
                 --with-lua-prefix=/usr \
                 --enable-cscope \
                 --with-x=yes \
                 --x-includes=/usr/include \
                 --x-libraries=/usr/lib64
# Make the binary and install it
make && make install

# Function to check whether command is available
is_installed() {
    [[ $(command -v $1 2>/dev/null) ]]
}

# Function to confirm if vim version shows a given feature flag
has_feature_flag() {
    [[ $($1 --version | grep $2) ]]
}

# Function to clean up after successful compile
clean_up() {
    cd
    rm -rf $VIM_DIR
    rm -f $SRC_DIR/$TAR_FILE
}

# Check results
if is_installed vim; then
    if ! has_feature_flag vim +lua; then
        echo "ERROR: Lua support was not compiled."
    elif ! has_feature_flag vim +python ; then
        echo "ERROR: Python support was not compiled."
    elif ! has_feature_flag vim +clipboard ; then
        echo "ERROR: Clipboard support was not compiled."
    else
        echo "Success: Vim supports Lua, Python, and clipboard."
        echo "Cleaning up."
        clean_up
        exit 0
    fi
else
    echo "ERROR: Vim was not compiled."
fi
echo "Please check for errors in $VIM_DIR/src/auto/config.log"
exit 1

