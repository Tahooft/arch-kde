#!/bin/bash
set -e


BUILDS=~/.builds

# Test of ~/.builds exists
if [ ! -d $BUILDS ]; then
  mkdir $BUILDS
fi
cd $BUILDS

echo "Input: "
read filename

# Test of ~/.builds/filename exists
if [ -d $BUILDS/$filename ]; then
   rm -Rf $BUILDS/$filename
fi

git clone https://aur.archlinux.org/${filename}.git
cd $filename
makepkg -sicr


echo "Done installing ${filename} from AUR"

