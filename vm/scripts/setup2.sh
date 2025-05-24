# this is to be run after chroot

set -o xtrace

hostname=lfsvm
rootPassword=password
deviceName=/dev/sda

# install some packages needed for the next part of setup
pacman -S --noconfirm dhcpcd sudo base-devel git vi vim

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# generate locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_GB.UTF-8" > /etc/locale.conf

# Set keymap
echo "KEYMAP=uk" > /etc/vconsole.conf

# add hostname entries:
echo "${hostName}" > /etc/hostname

# and hosts entries:
echo "127.0.0.1  localhost" >> /etc/hosts
echo "127.0.1.1  ${hostName}.localdomain ${hostName}" >> /etc/hosts

# set root password
echo "root:${rootPassword}" | sudo chpasswd

# install grub
pacman -S --noconfirm grub efibootmgr

# mount the efi system partition
mkdir /efi
mount ${deviceName}1 /efi

# install
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

# microcode
# why does this need to be here?
pacman -S --noconfirm intel-ucode

grub-mkconfig -o /boot/grub/grub.cfg

############# reboot
# reenable wifi

#iwctl station wlan0 connect SSID 
#dhcpcd

# create user account
#useradd -m gsej
#passwd gsej
#echo "gsej ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# for hibernate:

## get location of swap partition
#grep swap /etc/fstab

## modify /etc/default/grub:

## replacing GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
## with GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=de15a933-8322-455d-ba9d-3cdcb9dba512"

# update grub with:
#grub-mkconfig -o /boot/grub/grub.cfg

# update system
# edit /etc/mkinitcpio.conf adding "resume" to hooks line:
# HOOKS=(base udev autodetect modconf block filesystems keyboard resume fsck)

# regenerate 
#mkinitcpio -p linux.

# restart before hibernate starts working
# test with
#systemctl hibernate

