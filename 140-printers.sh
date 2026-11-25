#!/bin/bash
set -e

list=(
cups
cups-pdf
ghostscript
gsfonts
gutenprint
gtk3-print-backends
hplip # Linux drivers for HP printers and scanners
libcups
system-config-printer
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

echo "Enabling services"
sudo systemctl enable --now cups.service

echo "# PRINTER SETUP "
sudo pacman -S cups print-manager hplip python-pyqt5 --noconfirm --needed
sudo systemctl enable cups
echo "# PRINTER SETUP DONE "

echo "Software has been installed"

