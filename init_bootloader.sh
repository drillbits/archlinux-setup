#!/bin/bash

echo '>>> Set up bootloader'
set -x
bootctl --path=/mnt/boot install

cat << EOF > /mnt/boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=`sed -n 6p /mnt/etc/fstab|awk '{print $1}'` rw
EOF

sed -i 's/^/# /g' /mnt/boot/loader/loader.conf
echo "timeout 5" >> /mnt/boot/loader/loader.conf
{ set +x; } 2>/dev/null
