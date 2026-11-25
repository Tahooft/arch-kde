#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/install"


echo "Installation of the aur packages"


list=(
backintime
backintime-cli
brave-bin
btrfs-assistant
btrfs-desktop-notification
visual-studio-code-bin
youtube-dl
)

install list


echo "Software has been installed"

