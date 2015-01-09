#!/bin/bash

##
##
## Introduction
## ============
##
## It is a shell script. The purpose of this script is to scan a file or
## directory, and then replace some characters with given characters. So
## we name it as sar.sh (Scan And Replace). We can use it to preprocess
## the atom.config.in files in iqist/working/ctqmc/standard directory.
##
## This script should be used by the developer only.
##
## Usage
## =====
##
## ./sar.sh
##
## Before you start to use this shell script, you have to check and edit
## carefully the string pattern.
##
## For Mac OS X system, the grammar for sed is (we don't generate backup)
##     sed -i '' ...
##
## However, for Linux-based system, the grammar for sed is
##     sed -i ...
##
## Author
## ======
##
## This shell script is designed, created, implemented, and maintained by
##
## Li Huang // email: huangli712@gmail.com
##
## History
## =======
##
## 01/03/2015 by li huang
##
##

for i in *
do
    echo "current directory:"
    pwd
    cd $i
    echo "job directory:"
    pwd
    sed -i '' 's/AAA/aaa/g' file_name
    echo ''
    cd ..
done
