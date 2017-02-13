#!/bin/bash

#
# Script to compile Vim with Lua and Python support on CentOS7
#

# Create a local repo directory, and then a local repo using that directory
REPODIR="/var/lib/yum/repos/x86_65/7/local"
sudo mkdir -p $REPODIR
createrepo $REPODIR
sudo yum groups mark convert

# Create 'Development tools' install group
yum groupinstall 'Development tools'

# Install ncurses, Lua and Python developers' package
yum install ncurses ncurses-devel
sudo yum install lua-devel
sudo yum install python-devel

# Get the latest version of the Vim source code, unpack it
cd /usr/local/src
sudo wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
sudo tar -xjf vim-7.4.tar.bz2

# Configure the build along with any options we want to add
cd /usr/local/src/vim74
sudo ./configure --prefix=/usr \
                 --with-features=huge \
                 --enable-largefile \
                 --enable-pythoninterp \
                 --with-python-config-dir=/usr/lib64/python2.7/config \
                 --enable-gui=auto \
                 --enable-fail-if-missing \
                 --enable-luainterp \
                 --with-lua-prefix=/usr \
                 --enable-cscope

# Make the binary and install it
sudo make && sudo make install

# Function to check whether command is available
is_installed() {
    [[ $(command -v $1 2>/dev/null) ]]
}

# Function to confirm if vim version shows a given feature flag
has_feature_flag() {
    [[ $($1 --version | grep $2) ]]
}

read -r -d '' CHECK_ERRORS <<- EOM
Please check for errors in
    /usr/local/src/vim74/src/auto/config.log
EOM

# Check results
if is_installed vim; then
    if ! has_feature_flag vim +lua; then
        echo "ERROR: Lua support was not compiled."
    elif ! has_feature_flag vim +python ; then
        echo "ERROR: Python support was not compiled."
    else
        echo "Success: Vim supports Lua and Python."
        exit 0
    fi
else
    echo "ERROR: Vim was not compiled."
fi
echo $CHECK_ERRORS
exit 1

