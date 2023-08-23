#!/bin/bash
# Helper script to download and install lazygit for the right ARCH.
# https://github.com/jesseduffield/lazygit/releases/latest

if [ -n "$(which lazygit)" ]; then
        echo "lazygit is already installed."
	which lazygit
	exit
fi

VERSION="0.40.2"
OS="Linux"

case $(uname -m) in
	"armv7l")
		ARCH="armv6"
		;;
	"aarch64")
		ARCH="arm64"
		;;
	"x86_64")
		ARCH="x86_64"
		;;
# Multi matching example:
#	Italy | "San Marino" | Switzerland | "Vatican City")
#		echo -n "Italian"
#		;;
	*)
		echo "Unknown architecture $(uname -m)"
		exit
		;;
esac

# e.g. https://github.com/jesseduffield/lazygit/releases/download/v0.32.2/lazygit_0.32.2_Linux_x86_64.tar.gz
URL="https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_${OS}_${ARCH}.tar.gz"

echo "Downloading ${URL}..."
mkdir -p /tmp/lazygit
pushd /tmp/lazygit
wget -q -O- ${URL} | tar xfz -
#curl -L ${URL} | tar xfz -

echo "Install lazygit into ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
/bin/cp -r lazygit "$HOME/.local/bin"
popd
rm -fr /tmp/lazygit
