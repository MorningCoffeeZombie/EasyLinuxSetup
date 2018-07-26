#!/bin/sh
# Dependencies for full support: rsync. Rsync will be installed later in the script. 
# This script is to be used on the live disk, after installtion has finished.


TODAYSTD=`date '+%m/%d/%Y'`
TODAYISO=`date '+%Y%m%d-%H%M'`
BOLDFONT=$(tput bold)
NORMALFONT=$(tput sgr0)


#######################
# QUESTIONS TO SET VARS
#######################


# Boot support for UEFI systems
while true; do
    read -p "Are you installing on an SSD or a UEFI system? (y/n) " yn
    case $yn in
        [Yy]* ) SSDBOOT="install"; echo "Enter the UUID of your /boot drive: "; read BOOTUUID; BOOTDEVICE=`findfs UUID=$BOOTUUID`; BOOTTYPE=`blkid -o export $BOOTDEVICE | grep '^TYPE' | cut -d"=" -f2`; break;;
        [Nn]* ) SSDBOOT="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# SSD support for /tmp
while true; do
    read -p "Boot /tmp from another drive (SSD support)? (y/n) " yn
    case $yn in
        [Yy]* ) SSDTMP="install"; echo "Enter the UUID for your /tmp drive: "; read TMPUUID; TMPDEVICE=`findfs UUID=$TMPUUID`; TMPTYPE=`blkid -o export $TMPDEVICE | grep '^TYPE' | cut -d"=" -f2`; break;;
        [Nn]* ) SSDTMP="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# SSD support for /var
while true; do
    read -p "Boot /var from another drive (SSD support)? (y/n) " yn
    case $yn in
        [Yy]* ) SSDVAR="install"; echo "Enter the UUID for your /var drive: "; read VARUUID; VARDEVICE=`findfs UUID=$VARUUID`; VARYPE=`blkid -o export $VARDEVICE | grep '^TYPE' | cut -d"=" -f2`; break;;
        [Nn]* ) SSDVAR="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Where will the / be? Used for editing the proper /etc/fstab.
echo "Enter device name of the new (non-live) root system: "
echo "Example: /dev/sda1"
read DEVICE


##################
# RECAP AND REVIEW
##################


echo 
echo ${BOLDFONT}You have entered the following: ${NORMALFONT}
printf ${BOLDFONT}"ROOT DEVICE:${NORMALFONT} \t $DEVICE \n"
printf ${BOLDFONT}"MOUNT \t DEVICE \t FORMAT  UUID \n"${NORMALFONT}
printf "/boot \t $BOOTDEVICE \t $BOOTTYPE \t $BOOTUUID \n"
printf "/tmp \t $TMPDEVICE \t $TMPTYPE \t $TMPUUID \n"
printf "/var \t $VARDEVICE \t $VARTYPE \t $VARUUID \n"
echo 
if [ $BOOTUUID = $TMPUUID ] || [ $BOOTUUID = $VARUUID ]; then
	echo The /boot UUID may not be on the same partition.
	echo Please restart program, exiting now.
	exit
fi&>/dev/null
if [ $TMPUUID = $VARUUID ]; then
	echo Multi partition mounting is not yet supported by ${0##*/}.
	echo Please restart program, exiting now.
	exit
fi&>/dev/null
while true; do
    read -p "Is this correct? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please restart program, exiting now"; exit; break;;
        * ) echo "Please answer yes or no.";;
    esac
done



#########################
# MAKE ADDITIONS TO FSTAB
#########################


sudo mount $DEVICE /run/media/live/
sudo echo \# Added $TODAYSTD during live-disk install by ${0##*/}>>/run/media/live/etc/fstab
if [ $SSDBOOT = "install" ]; then
	sudo echo UUID=$BOOTUUID /boot $BOOTTYPE defaults 0 0 >>/run/media/live/etc/fstab
fi
if [ $SSDTMP = "install" ]; then
	sudo echo UUID=$TMPUUID /tmp $TMPTYPE defaults 0 1 >>/run/media/live/etc/fstab
fi
if [ $SSDVAR = "install" ]; then
	sudo echo UUID=$VARUUID /var $VARTYPE defaults 0 1 >>/run/media/live/etc/fstab
fi


##############################
# RSYNC FILES TO NEW LOCATIONS
##############################


# rsync needs 1. sudo throughout 2. -a to retain permissions 3. probably -v or --progress 4. -delete t clear the destination dir 5. rename the source dirs so they arent used at reboot
sudo eopkg install rsync -y
if [ $SSDTMP = "install" ]; then
	sudo rsync -a -delete --progress /run/media/live/tmp/ $TMPDEVICE/
	sudo mv /tmp /tmp.BAK$TODAYISO
fi

if [ $SSDVAR = "install" ]; then
	sudo rsync -a -delete --progress /run/media/live/var/ $VARDEVICE/
	sudo mv /var /var.BAK$TODAYISO
fi






umount $DEVICE
exit
##################
# UNUSED RESOURCES
##################


#sudo blkid | grep $BOOTUUID



###################
# DEV NOTES / TO DO
###################

# Script now just detects the partition type, do not have to ask the user
	# https://www.thegeekstuff.com/2011/04/identify-file-system-type/
	# https://unix.stackexchange.com/questions/60723/how-do-i-know-if-a-partition-is-ext2-ext3-or-ext4
# rsync, is not preinstalled on a live disk by default...
# BUG: If the only mount point you  make is /boot you do not get asked to confirm your selections
# rsync help:	https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/

