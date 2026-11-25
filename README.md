# Arch KDE Setup

A collection of Bash scripts and dotfiles for setting up and customizing an Arch Linux system running KDE Plasma.

This repository reflects a personal workstation setup. Review and adapt the scripts before running them, because they install packages, enable system services, change system configuration, and may require hardware-specific settings.

## Included

- Package installation scripts for official Arch repositories and the AUR
- NVIDIA and NVIDIA container setup
- Bluetooth, printer, Samba, laptop, virtualization, Chinese locale, and font configuration
- Git identity configuration
- Example Bash dotfiles
- Package lists for Arch and foreign/AUR packages

## Requirements

- A supported Arch Linux installation
- `sudo` access
- An active internet connection
- KDE Plasma or a compatible desktop environment
- `pacman`, `bash`, and standard Linux system tools
- `yay` or `makepkg` for the AUR scripts where indicated

Most scripts are designed for x86-64 desktop or laptop systems. The NVIDIA script should only be run on a compatible NVIDIA GPU and should be reviewed before use.

## Repository layout

| Path | Purpose |
| --- | --- |
| `040-general-software.sh` | Installs desktop, multimedia, font, development, and utility packages |
| `070-aur-software.sh` | Installs a selected list of AUR packages with `yay` |
| `030-nvidia.sh` | Installs NVIDIA DKMS, utilities, settings, and Prime packages |
| `050-needs-setup-software.sh` | Configures firewall, Docker, printers, SSH, and related services |
| `060-aur-install-input.sh` | Builds and installs an AUR package named interactively |
| `080-chinese.sh` | Adds Chinese fonts and locale configuration guidance |
| `090-setup-git.sh` | Initializes Git and sets global Git configuration |
| `100-virt-manager` | Installs QEMU/KVM, libvirt, networking support, and Virtual Machine Manager; enables libvirt |
| `130-bluetooth.sh` | Installs and enables Bluetooth software and service |
| `140-printers.sh` | Installs and enables CUPS printing software |
| `150-samba.sh` | Installs Samba, copies an ArcoLinux config, and creates a Samba user |
| `160-laptop.sh` | Installs and enables TLP |
| `install` | Shared helper called with a Bash array name and optional manager, for example `install list` or `install list yay` |
| `generate-package-list.sh` | Generates a package inventory from numbered scripts |
| `package-lists/package-list-YYMMDD.txt` | Dated package inventory grouped by Pacman, Yay, and Flatpak |
| `pkglist.txt` | Arch repository package snapshot or package selection |
| `foreignpkglist.txt` | AUR and other foreign package snapshot or package selection |
| `Dots/` | Example Bash, font, Git, and NVIDIA configuration files |

## Before use

Back up any existing configuration and inspect each script:

```bash
cp -a ~/.bashrc ~/.bashrc.backup
cp -a ~/.gitconfig ~/.gitconfig.backup
cp -a ~/.config ~/.config.backup
```

Review paths, usernames, package names, hardware assumptions, and services that are enabled by the scripts. Do not run a script without understanding the changes it makes.

Several scripts use `sudo`, and some modify files under `/etc` or enable services. A script can fail with `set -e` before all of its intended setup is complete.

## Usage

Clone the repository:

```bash
git clone https://github.com/Tahooft/arch-kde.git
cd arch-kde
```

Make an executable script runnable if needed:

```bash
chmod +x 040-general-software.sh
./040-general-software.sh
```

Run only the scripts appropriate for your machine. For example:

```bash
# General packages
./040-general-software.sh

# Optional hardware or system components
./130-bluetooth.sh
./140-printers.sh
./160-laptop.sh
```

For AUR packages:

```bash
./070-aur-software.sh
```

Alternatively, install an AUR package by name:

```bash
./060-aur-install-input.sh
```

Enter the package name, without the URL or repository prefix, when prompted.

## Package snapshots

The package list files can be used as references or as inputs for your own package restore workflow:

```bash
# Review packages from the official repository list
cat pkglist.txt

# Review packages from the foreign/AUR list
cat foreignpkglist.txt
```

Generate an inventory of package selections referenced by the numbered scripts:

```bash
./generate-package-list.sh
```

This writes `package-lists/package-list-YYMMDD.txt`, with the current date in `YYMMDD` format, grouped by Pacman, Yay, and Flatpak. Inline comments on package entries are included. It lists configured package selections; it does not detect which packages are installed on the current system.

## Dotfiles

Dotfiles are stored in `Dots/` without the `.gitconfig` user identity necessarily matching every system. Review them before copying:

```bash
cp Dots/.bashrc ~/.bashrc
cp Dots/.bash_profile ~/.bash_profile
cp Dots/.gitconfig ~/.gitconfig
cp Dots/.fonts.conf ~/.fonts.conf
```

The `.gitconfig` file contains a personal name and email. Update it before use:

```ini
[user]
	name = Your Name
	email = your-email@example.com
```

After copying `.bashrc`, reload it:

```bash
source ~/.bashrc
```

## Git setup

Before running `090-setup-git.sh`, replace the placeholder values in the script:

```bash
./090-setup-git.sh
```

The script initializes Git in the current directory, configures global identity and credentials, and sets a default push behavior.

## NVIDIA setup

`030-nvidia.sh` targets NVIDIA proprietary drivers and tools. Kernel, firmware, GPU, and Arch kernel choices must be compatible with the selected packages.

Review the script and the current Arch Wiki installation guidance for your kernel and GPU before running it. For a list of currently installed NVIDIA packages:

```bash
pacman -Q | grep -i nvidia
```

## Notes

- Package availability and package names can change.
- Scripts derived from other distributions or distributions-specific configurations may not apply directly to Arch Linux.
- `150-samba.sh` assumes an ArcoLinux-provided `/etc/samba/smb.conf.arcolinux` template.
- `080-chinese.sh` opens `/etc/locale.gen` with Neovim and requires locale entries to be uncommented manually.
- `090-setup-git.sh` contains placeholder identity values and should be edited before use.
- `060-aur-install-input.sh` removes an existing build directory before cloning the requested AUR package.

## Contributing

Changes should preserve or improve the scripts' existing behavior. When adding a script or package:

1. Add a descriptive filename and package list.
2. Preserve `set -e` where appropriate.
3. Check whether packages are already installed before installing them.
4. Document required manual steps and system assumptions.
5. Test changes on a disposable or non-production Arch system.

## License

No license has been included in this repository. All rights remain with the repository owner unless a license is added.
