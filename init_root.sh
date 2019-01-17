#!/bin/bash

echo -n 'host name: '
read hostname
: ${hostname:="ciel"}

echo -n 'user name: '
read username
: ${username:="drillbits"}

echo '>>> Create user'
set -x
useradd -m -g users -G wheel -s /bin/bash ${username}
passwd ${username}
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
{ set +x; } 2>/dev/null

echo '>>> Install initial tools'
set -x
pacman -Syu --noconfirm
pacman -S --noconfirm vim git ca-certificates
# pacman -Qo /etc/ssl/certs/ca-certificates.crt
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
set -x
echo ${hostname} > /etc/hostname
echo "127.0.1.1 ${hostname}.localdomain    ${hostname}" >> /etc/hosts
{ set +x; } 2>/dev/null

echo '>>> Setup network'
set -x
pacman -S --noconfirm iw wpa_supplicant networkmanager
systemctl enable NetworkManager
{ set +x; } 2>/dev/null

echo '>>> Initramfs'
set -x
mkinitcpio -p linux
{ set +x; } 2>/dev/null

echo '>>> Update Microcode'
set -x
pacman -S --noconfirm intel-ucode
{ set +x; } 2>/dev/null

echo '>>> Setup X'
set -x
pacman -S --noconfirm xf86-video-intel xorg-server xorg-apps
{ set +x; } 2>/dev/null

echo '>>> Setup display manager: GDM'
set -x
pacman -S --noconfirm gdm
systemctl enable gdm.service
{ set +x; } 2>/dev/null

echo '>>> Setup desktop environment: GNOME'
set -x
pacman -S --noconfirm gnome gnome-extra network-manager-applet
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

echo '>>> Setup touchpad'
set -x
pacman -S --noconfirm xf86-input-libinput xorg-xinput
echo 'Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "NaturalScrolling" "true"
  Option "ClickMethod" "buttonareas"
EndSection' >> /etc/X11/xorg.conf.d/90-libinput.conf
{ set +x; } 2>/dev/null

echo '>>> Setup input method'
set -x
# delete values of sources via org -> gnome -> desktop -> input-sources
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"
pacman -S --noconfirm fcitx fcitx-mozc fcitx-configtool fcitx-im fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5
# echo 'export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS=@im=fcitx
# export DefaultIMModule=fcitx' > ~/.xprofile
echo 'export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx' >> /etc/environment
{ set +x; } 2>/dev/null

echo '>>> Setup Japanese font'
set -x
pacman -S --noconfirm otf-ipafont noto-fonts-cjk-otf adobe-source-han-serif-otc-fonts
{ set +x; } 2>/dev/null