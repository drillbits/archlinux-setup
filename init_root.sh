#!/bin/bash

echo '>>> Install initial tools'
set -x
pacman -Syu
pacman -S vim git ca-certificate
{ set +x; } 2>/dev/null

echo '>>> Set timezone'
set -x
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
{ set +x; } 2>/dev/null

echo '>>> Set hardware clock'
set -x
hwclock --systohc --utc
{ set +x; } 2>/dev/null

echo '>>> Set locale'
set -x
sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sed -i '/^#ja_JP.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
{ set +x; } 2>/dev/null

echo '>>> Set hostname'
echo -n 'host name: '
read hostname
: ${hostname:="ciel"}
set -x
echo ${hostname} > /etc/hostname
# /etc/hosts
# 127.0.1.1 ciel.localdomain ciel
{ set +x; } 2>/dev/null

echo '>>> Create user'
echo -n 'user name: '
read username
: ${username:="drillbits"}
set -x
useradd -m -g users -G wheel -s /bin/bash ${username}
passwd ${username}
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
{ set +x; } 2>/dev/null

echo '>>> Setup X'
set -x
pacman -S xf86-video-intel
pacman -S xorg-server xorg-apps
{ set +x; } 2>/dev/null

echo '>>> Setup display manager: GDM'
set -x
pacman -S gdm
systemctl enable gdm.service
{ set +x; } 2>/dev/null

echo '>>> Setup desktop environment: GNOME'
set -x
pacman -S gnome gnome-extra network-manager-applet
{ set +x; } 2>/dev/null

# echo '>>> Setup Window manager: '
# set -x
# { set +x; } 2>/dev/null

echo '>>> Setup console keyboard'
set -x
# echo options hid_apple iso_layout=0 >> /etc/modprobe.d/hid_apple.conf
mkdir -p /usr/local/share/kbd/keymaps
dumpkeys | head -1 | tee /usr/local/share/kbd/keymaps/personal.map
echo keycode 58 = Control >> /usr/local/share/kbd/keymaps/personal.map
loadkeys /usr/local/share/kbd/keymaps/personal.map
echo KEYMAP=/usr/local/share/kbd/keymaps/personal.map >> /etc/vconsole.conf
{ set +x; } 2>/dev/null