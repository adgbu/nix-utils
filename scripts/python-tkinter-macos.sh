#!/bin/bash

# Forget everything in this script! 
# The problem is that Python 3.11 does not tolerate Tk > 8.6
# The correct solution is to install the older tcl-tk version 8.6
# brew uninstall tcl-tk
# brew list | grep tcl
# Should be gone. 
# brew install tcl-tk@8
exit

# Installing Python on macOS with working tkinter requires some workarounds.
# This script assumes "brew" and "pyenv" on macOS and that tcl-tk is already installed by brew.
#
# Read more about this on Stack Overflow:
# "Unable to install Tkinter with pyenv Python instances on macOS"
# https://stackoverflow.com/questions/60469202/unable-to-install-tkinter-with-pyenv-python-instances-on-macos

# Check that exactly one argument is provided.
if [ "$#" -ne 1 ]; then
  echo "Usage:"
  echo "$0 <python version to install>"
  exit 1
fi

PREFIX="$(brew --prefix tcl-tk)"
echo "tcl-tk prefix:"
echo ${PREFIX}
echo

export PATH="${PREFIX}/bin:$PATH"
export LDFLAGS="-L${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include"
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"
export CFLAGS="-I${PREFIX}/include"

VERSION="9.0"
export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I${PREFIX}/include' --with-tcltk-libs='-L${PREFIX}/lib -ltcl${VERSION} -ltk${VERSION}'"
echo "PYTHON_CONFIGURE_OPTS:"
echo ${PYTHON_CONFIGURE_OPTS}
echo

echo "Run pyenv install $1 ?"
printf "Press Enter to continue..."
read _

pyenv install $1
