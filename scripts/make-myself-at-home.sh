#!/bin/sh

# This is a convenience script for initial setup on a vanilla Raspberry Pi.
# It will setup some things that I like to have on all systems.
# Make yourself at home!


if [ $# == 2 ]; then
	# Configure git with personal info.
	NAME="$1 ($(whoami)@$(hostname))"
	EMAIL="$2"
	echo "Configuring git identity: $NAME, $EMAIL"
	git config --global user.name "$NAME"
	git config --global user.email "$EMAIL"
fi

echo "Hooking you up with some sweet command aliases..."
ln -sf "$HOME/rpi-utils/bash_aliases" "$HOME/.bash_aliases"

echo "Hooking you up with a custom bash prompt..."
ln -sf "$HOME/rpi-utils/bash_prompt" "$HOME/.bash_prompt"
printf "\n# Custom bash prompt\n. ~/.bash_prompt" >> ~/.bashrc

# ~/.local/bin will be in PATH automatically iff it exists.
echo "Creating ~/.local/bin to put local executables in..."
mkdir -p "$HOME/.local/bin"

# Install lazygit
sh ~/rpi-utils/lazygit-setup.sh
