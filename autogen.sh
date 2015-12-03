#!/bin/sh -e
# Author: Jorge Pereira <jpereiran@gmail.com>
# Date: Qua Dez  2 18:01:38 BRST 2015
##

parentdir=`dirname $0`

cd $parentdir
parentdir=`pwd`

#libtoolize -f -c
aclocal
autoheader
autoconf

