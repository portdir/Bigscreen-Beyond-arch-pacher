# by portdir 11/19/25
# V 1.6
# BSB updater made for 6.17.7 arch

cd ~/Desktop/
# get tool
sudo pacman -S devtools base-devel pacman-contrib

# fix usb stuff i think
sudo install -m 0644 /dev/stdin /etc/udev/rules.d/71-bigscreen-beyond.rules << 'EOF'
# Bigscreen Beyond access for seated user
SUBSYSTEM=="usb", ATTR{idVendor}=="35bd", TAG+="uaccess"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", TAG+="uaccess"
EOF

sudo udevadm control --reload
sudo udevadm trigger

lsusb -d 35bd:0101 || true
lsusb -d 35bd:4004 || true

# start building

# ++++++++++++++++++++++++++++++++
# things to add
# sudo nano /etc/makepkg.conf
# MAKEFLAGS="-j$(nproc)"
#
# this build file is to big for this might need to look in to it
# BUILDDIR=/tmp/makepkg
# ++++++++++++++++++++++++++++++++

mkdir buildingthatvrlinuxthing
cd buildingthatvrlinuxthing
pkgctl repo clone --protocol=https linux
cd linux

# edit PKG
# rename pkgbase
sed -i 's/pkgbase=linux/pkgbase=BSBvrARCH/g' PKGBUILD
# build faster
sed -i 's/make htmldocs/#make htmldocs/g' PKGBUILD
sed -i 's/"$pkgbase-docs"/#"$pkgbase-docs"/g' PKGBUILD
# add bsb patch 6.17.7
sed -i '/source=/a\
https://lvra.gitlab.io/docs/other/bigscreen-beyond/bigscreen-beyond-kernel.patch' PKGBUILD

# buid
updpkgsums
time makepkg -s --skippgpcheck
# add to pacman
sudo pacman -U BSBvrARCH-*.pkg.tar.zst

# add to boot lodder (WIP)

# grub
#sudo grub-mkconfig -o /boot/grub/grub.cfg

# systemd-boot
# /boot/loader/entries/
#echo "title   BSB Arch Linux (linux)
#linux   /vmlinuz-BSBvrARCH
#initrd  /initramfs-BSBvrARCH.img
#options root=PARTUUID=?????????????????? rw rootfstype=????" >> /boot/loader/entries/BSBvrARCH.conf

# clean up
rm -rf ~/Desktop/buildingthatvrlinuxthing

#===============================================================================================

# VR ADD ONS

#mkdir ~VRthings/
# wlx overlay
#curl -O https://github.com/galister/wlx-overlay-s/releases/download/v25.4.2/WlxOverlay-S-v25.4.2-x86_64.AppImage
#mv WlxOverlay-S-v25.4.2-x86_64.AppImage ~/VRthings/
#chmod +x ~VRthings/WlxOverlay-S-v25.4.2-x86_64.AppImage

# envision
#yay -S envision-xr-git
#sudo pacman -Syu wayland-protocols
#yay -S libudev0-shim

# vr  stuff
#yay -S opencomposite-git xrizer-git

# protonup-qt
#yay -S protonup-qt

#===============================================================================================
