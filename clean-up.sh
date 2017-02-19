#!/bin/bash

#
# Script to clean up after compile of Vim
#
# MAKE SURE TO RUN THIS SCRIPT WITH sudo, e.g.:
#      sudo ./clean-up.sh
#
cd
rm -rf /usr/local/src/vim74
rm -f /usr/local/src/TAR_FILE=vim-7.4.tar.bz2

