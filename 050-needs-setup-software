#!/bin/bash
set -e

echo "Enable GUFW simple firewall"
sudo pacman -S ufw gufw ufw-extras --noconfirm --needed
sudo ufw enable
sudo systemctl enable ufw
sudo systemctl start ufw
echo "GUFW enabled "


echo " CREATE KEYPAIR "
# create keypair if missing - ook voor GIT nodig
sudo ssh-keygen -A
echo "KEYPAIR GENERATED "


echo " SETUP DOCKER "
sudo pacman -S docker docker-compose --noconfirm --needed
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
echo "DOCKER SETUP DONE "


echo "# FSTRIM SETUP "
# sudo systemctl start fstrim.timer
# sudo systemctl enable fstrim.timer
echo "# FSTRIM SETUP DONE "
