#! /bin/bash

do_unmount_all_partitions()
{
MMCDEV=$1
umount ${MMCDEV}*
}

do_create_partitions()
{

	echo "Storage size is 8GB. Only for Development purposes"
	BOOT_SIZE=250M
	ROOTFS_SIZE=2048M

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${1}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default 
  +${BOOT_SIZE} #  boot partition
  n # new partition
  p # primary partition
  2 # partition number 2
    # default
  +${ROOTFS_SIZE} # Rootfs2 partition
  w # write the partition table
  q # and we're done
EOF

if [ $? -ne 0 ]
then
	echo "Partition creation failed!!!"
	exit 1
fi

echo "Created partitions successfully......."
echo "---------------------------------------------------------------"
echo "	Boot			: ${BOOT_SIZE}"
echo "	Rootfs			: ${ROOTFS_SIZE}"
echo "---------------------------------------------------------------"

}

do_format_partitions()
{
MMCDEV=$1

umount ${MMCDEV}1
mkfs.vfat ${MMCDEV}1 -n boot
if [ $? -ne 0 ]
then
	echo "${MMCDEV}1 format failed!!!"
	exit 1
fi

umount ${MMCDEV}2
mkfs.ext4 -F ${MMCDEV}2 -L rootfs
if [ $? -ne 0 ]
then
	echo "${MMCDEV}2 format failed!!!"
	exit 1
fi
}

do_make_img_file()
{
mkfs.ubifs -F -x lzo -m 2048 -e 126976 -c 2048 -o rootfs_ubifs.img -d ./75XX_TNSTC_FILESYSTEM
ubinize -o 75xx_tnstc.img -m 2048 -p 131072 -O 2048 -s 2048 ./rootfs_ubinize.cfg
chmod 777 75xx_tnstc.img
cp 75xx_tnstc.img ./base_filesystem/usr/fs/ubi_match.img
sync
}

do_flash_data_into_partitions()
{
MMCDEV=$1

mkdir -p /media/$SUDO_USER/boot
mkdir -p /media/$SUDO_USER/root

mount ${MMCDEV}1 /media/$SUDO_USER/boot
mount ${MMCDEV}2 /media/$SUDO_USER/root

rm /media/$SUDO_USER/boot/* -rf
rm /media/$SUDO_USER/root/* -rf
sync

cp ./base_kernel/uImage /media/$SUDO_USER/boot/
echo "Kernel File Flashed - Success"

cp ./base_filesystem/* /media/$SUDO_USER/root/ -rf
echo "Filesystem Flashed - Success"
echo "Synchronizing.... "
sync
}

#Check for the root permission
echo "Starting the script $UID"
if [ $UID -ne 0 ]
then
    echo "Run script with root permission!!!"
    exit 1
fi

#check for input argument
if [ $# -ne 1 ]
then
    echo "device name argument is missing!!!"
    echo "Eg:- $0 /dev/sdb "
    exit 1
fi

#Function to unmount the Flash drive
do_unmount_all_partitions $1

#cross check is the provided eMMC is the current boot
CURRENT_BOOT_DEVICE=`mount | grep -i /boot | cut -d' ' -f 1 | sed -e 's/[1-9]//g'`
if [ ${CURRENT_BOOT_DEVICE} = "$1" ]
then
    echo "$1 is the current boot device. Can't perform partition of online or active device!!!!"
    exit 1
fi

#Function for partition creation
do_create_partitions $1

#Function format partitions
do_format_partitions $1

#Function to generate img file (filesystem)
do_make_img_file

#Function to flash files into partitions
do_flash_data_into_partitions $1

echo "---------------------------------------"
echo "Flash partition creation successs"
echo "Kernel and Filesystem - Ready Flash"
echo "---------------------------------------"
