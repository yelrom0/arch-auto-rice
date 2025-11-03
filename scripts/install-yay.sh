#!/usr/bin/env bash

# Check if running as root (UID 0)
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Elevating privileges..."
    exec sudo -- "$0" "$@"
fi

WORKDIR="./build"

ehco "Installing Yay and its dependancies"
mkdir -p "$WORKDIR" && cd "$WORKDIR"
pacman -Syu && pacman -S --needed git base-devel

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
# We need the right package name, it should be the only
# file ending in ".pkg.tar"
YAY_PACKAGE=$(ls | grep ".pkg.tar")
# Now we need to install the package from the name we got
# in the last command
pacman -U "./$YAY_PACKAGE"
echo "Yay and its dependancies are now installed"

rm -rf "$WORKDIR"