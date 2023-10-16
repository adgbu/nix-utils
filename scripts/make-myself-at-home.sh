#!/bin/sh

# This is a convenience script for initial setup on a vanilla Raspberry Pi.
# It will setup some things that I like to have on all systems.
# Make yourself at home!

BASE=$HOME/nix-utils

if [ $# -eq 2 ]; then
	# Configure git with personal info.
	NAME="$1 ($(whoami)@$(hostname))"
	EMAIL="$2"
	echo "Configuring git identity: $NAME, $EMAIL"
	git config --global user.name "$NAME"
	git config --global user.email "$EMAIL"
fi

echo "Hooking you up with some sweet command aliases..."
ln -sf "$BASE/bash/aliases" "$HOME/.bash_aliases"

echo "Hooking you up with a custom bash prompt..."
ln -sf "$BASE/bash/bash_prompt" "$HOME/.bash_prompt"
printf "\n# Custom bash prompt\n. ~/.bash_prompt" >> ~/.bashrc

echo "Appending .bashrc to get things rolling..."
cat "$BASE/bash/bashrc" >> "$HOME/.bashrc"

# ~/.local/bin will be in PATH automatically iff it exists.
echo "Creating ~/.local/bin to put local executables in..."
mkdir -p "$HOME/.local/bin"
