# by portdir 11/19/25
# V 1.5
# BSB updater made for 6.17.7 arch

cd cd ~/Desktop/
# get tool

sudo pacman -S devtools base-devel pacman-contrib

#fix usb stuff i think
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
# this file is to big for this might need to look in to it
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

# add to grub+
# sudo grub-mkconfig -o /boot/grub/grub.cfg

# clean up
rm -rf ~/Desktop/buildingthatvrlinuxthing

# vr add ons

#mkdir ~VRthings/

# wlx
#curl -O https://github.com/galister/wlx-overlay-s/releases/download/v25.4.2/WlxOverlay-S-v25.4.2-x86_64.AppImage

#mv WlxOverlay-S-v25.4.2-x86_64.AppImage ~/VRthings/
#chmod +x ~VRthings/WlxOverlay-S-v25.4.2-x86_64.AppImage

