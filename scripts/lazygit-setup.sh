#!/bin/bash
# Helper script to download and install lazygit for the right OS and ARCH.
# https://github.com/jesseduffield/lazygit/releases/latest

# Manually set the version to download from releases.
VERSION="0.40.2"

# Check if lazygit is already installed.
if [ -n "$(which lazygit)" ]; then
        echo "lazygit is already installed."
	which lazygit
	exit
fi

# Automatically detect the OS and ARCH.
# On macOS uname -o will return Darwin directly.
OS="$(uname -o)"
case $OS in
	"GNU/Linux")
		# Remap GNU/Linux to Linux.
		OS="Linux"
		;;
esac

# On macOS uname -m will return "arm64" or "x86_64" directly.
ARCH="$(uname -m)"
case $ARCH in
	"armv7l")
		# On Raspberry Pi remap armv7l to armv6.
		ARCH="armv6"
		;;
	"aarch64")
		# On Raspberry Pi remap aarch64 to arm64.
		ARCH="arm64"
		;;
# Multi matching example:
#	Italy | "San Marino" | Switzerland | "Vatican City")
#		echo -n "Italian"
#		;;
esac

# e.g. https://github.com/jesseduffield/lazygit/releases/download/v0.32.2/lazygit_0.32.2_Linux_x86_64.tar.gz
URL="https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_${OS}_${ARCH}.tar.gz"

TMPDIR="/tmp/lazygit"
echo "Downloading ${URL}..."
mkdir -p "$TMPDIR"
cd "$TMPDIR"
#wget -q -O- ${URL} | tar xfz -
curl -L ${URL} | tar xfz -

BINDIR="$HOME/.local/bin"
echo "Install lazygit into $BINDIR..."
mkdir -p "$BINDIR"
cd "$BINDIR"
/bin/cp -r "$TMPDIR/lazygit" "$BINDIR"
rm -fr "$TMPDIR"
