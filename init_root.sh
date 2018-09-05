#!/bin/bash

echo '>>> Install initial tools'
set -x
pacman -Syu
pacman -Sy vim
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
sed -i '/^# en_US.UTF-8 UTF-8/s/^# //' /etc/locale.gen
sed -i '/^# ja_JP.UTF-8 UTF-8/s/^# //' /etc/locale.gen
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