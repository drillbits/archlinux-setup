#!/bin/bash

echo '>>> Create workspace'
set -x
mkdir ~/src ~/bin ~/pkg
{ set +x; } 2>/dev/null

echo '>>> Setup pikaur'
set -x
mkdir ~/src/aur.archlinux.org
cd ~/src/aur.archlinux.org
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri
pikaur -Syu
{ set +x; } 2>/dev/null

echo '>>> Setup fonts'
set -x
pikaur -S --noconfirm noto-fonts-cjk-otf adobe-source-han-serif-otc-fonts
{ set +x; } 2>/dev/null

echo '>>> Setup Go'
set -x
wget https://dl.google.com/go/go1.4.3.linux-amd64.tar.gz
tar xvf go1.4.3.linux-amd64.tar.gz
mv go go1.4
rm go1.4.3.linux-amd64.tar.gz
mkdir -p ~/src/github.com/golang
cd ~/src/github.com/golang
git clone https://github.com/golang/go.git
cd go
git checkout go1.11.4
cd src
./make.bash
{ set +x; } 2>/dev/null

echo '>>> Setup dotfiles'
mkdir -p ~/src/github.com/drillbits
cd ~/src/github.com/drillbits
git clone git@github.com:drillbits/dotfiles.git
cd dotfiles
make
{ set +x; } 2>/dev/null