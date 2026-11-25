#!/bin/bash
set -o errexit

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/install"

list=(

cups
ghostscript
gsfonts
gutenprint
gtk3-print-backends
hplip # Linux drivers for HP printers and scanners
libcups
print-manager
system-config-printer
python-pyqt5
)


if ! install list; then
	echo "Package installation failed; CUPS was not enabled." >&2
	exit 1
fi


echo "Enabling services"
sudo systemctl enable cups.service


echo "Software has been installed"