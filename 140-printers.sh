
list=(
cups
cups-pdf
ghostscript
gsfonts
gutenprint
gtk3-print-backends
libcups
system-config-printer
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

###############################################################################

tput setaf 5;echo "################################################################"
echo "Enabling services"
echo "################################################################"
echo;tput sgr0

sudo systemctl enable --now cups.service

tput setaf 11;
echo "################################################################"
echo "Software has been installed"
echo "################################################################"
echo;tput sgr0
