#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/install"

list=(

tlp # Linux Advanced Power Management

)


if ! install list; then
	echo "Package installation failed; TLP was not enabled." >&2
	exit 1
fi


echo "Enabling services"
sudo systemctl enable tlp.service


echo "Software has been installed"