set -o xtrace

hostname=lfsvm
rootPassword=password
deviceName=/dev/sda

# Partition the disk

parted -s $deviceName mklabel gpt
parted -s $deviceName mkpart primary fat32 1MiB 513MiB
parted -s $deviceName set 1 esp on
parted -s $deviceName mkpart primary ext4 513MiB 100%

mkfs.fat -F 32 ${deviceName}1
mkfs.ext4 -F ${deviceName}2

parted $deviceName print

# set keyboard layout
loadkeys uk

# update system clock
timedatectl set-ntp true

# base system

mount /dev/sda2 /mnt
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt > /mnt/etc/fstab

mkdir /mnt/scripts
cp setup2.sh /mnt/scripts/

arch-chroot /mnt

