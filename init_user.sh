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
