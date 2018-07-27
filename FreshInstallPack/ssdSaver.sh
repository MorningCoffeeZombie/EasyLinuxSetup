#!/bin/sh
# Dependencies for full support: rsync. Rsync will be installed later in the script. 
# This script is to be used on the live disk, after installtion has finished.


TODAYSTD=`date '+%m/%d/%Y'`
TODAYISO=`date '+%Y%m%d-%H%M'`
BOLDFONT=$(tput bold)
NORMALFONT=$(tput sgr0)
PERMCHECK=`sudo -n uptime 2>&1|grep "load"|wc -l`


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

# Where will the / (/root) be? Used for editing the proper /etc/fstab.
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

if [ $BOOTUUID = $TMPUUID ] || [ $BOOTUUID = $VARUUID ] && [ $TMPUUID -ne "" ] && [ $VARUUID -ne "" ] ; then
	echo The /boot UUID may not be share its partition.
	echo Please restart program, exiting now.
	exit
fi

if [ $TMPUUID = $VARUUID ] && [ $TMPUUID -ne "" ] ; then
	echo Multi partition mounting is not yet supported by ${0##*/}.
	echo Please restart program, exiting now.
	exit
fi

while true; do
    read -p "Is this correct? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Entering override mode"; OVERRIDE=true; break;;
        * ) echo "Please answer yes or no.";;
    esac
done


#################
# OVERRIDE MODULE
#################


if [ $OVERRIDE = "true" ]; then
	PS3='What was wrong: '
	options=("/boot" "/tmp" "/var" "The new /root device" "Multiple" "Nothing, please go back" "Quit")
	select wrong in "${options[@]}"
	do
		case $wrong in
		"/boot")
			BOOTWRONG=true; break;;
		"/tmp")
			TMPWRONG=true; break;;
		"/var")
			VARWRONG=true; break;;
		"The new /root device")
			DEVICEWRONG=true; break;;
		"Multiple")
			ALLWRONG=true; echo "Everything is wrong. We'll try this the hard way"; break;;
		"Nothing, please go back")
			echo "This script will now continue as-is"; break;;
		"Quit")
			echo "Quiting program"; exit; break;;
		*) echo "Invalid option $REPLY";;
		esac
done
fi

if [ $BOOTWRONG = "true" ]; then
	echo "Enter your /boot device name"
	echo "Example: /dev/sda1"
	read BOOTDEVICE
	echo "Enter your /boot partition type (remember FAT32=vfat)"
	read BOOTTYPE
fi

if [ $TMPWRONG = "true" ]; then
	echo "Enter your /tmp device name"
	echo "Example: /dev/sda1"
	read TMPDEVICE
	echo "Enter your /tmp partition type (remember FAT32=vfat)"
	read TMPTYPE
fi

if [ $VARWRONG = "true" ]; then
	echo "Enter your /var device name"
	echo "Example: /dev/sda1"
	read VARDEVICE
	echo "Enter your /var partition type (remember FAT32=vfat)"
	read VARTYPE
fi

if [ $DEVICEWRONG = "true" ]; then
	echo "Enter destination /root device"
	read DEVICE
fi

if [ $ALLWRONG = "true" ]; then
	echo "Enter your /boot device name"
	echo "Example: /dev/sda1"
	read BOOTDEVICE
	echo "Enter your /boot partition type (remember FAT32=vfat)"
	read BOOTTYPE
	echo "Enter your /tmp device name"
	echo "Example: /dev/sda1"
	read TMPDEVICE
	echo "Enter your /tmp partition type (remember FAT32=vfat)"
	read TMPTYPE
	echo "Enter your /var device name"
	echo "Example: /dev/sda1"
	read VARDEVICE
	echo "Enter your /var partition type (remember FAT32=vfat)"
	read VARTYPE
fi


##############
# SUDO TRIGGER
##############

echo "Root permissions are required to install and use rsync "
# Using a benign echo command to trigger password. This is the user's last chance to quit before writing to drives
sudo echo "Initiating"

if [ $PERMCHECK -le 0 ]; then
	echo "This script cannot complete without rsync and the ability to edit /etc/fstab"
	sudo echo "Please confirm password"
	PERMCHECK=`sudo -n uptime 2>&1|grep "load"|wc -l`
fi

if [ $PERMCHECK -le 0 ]; then
	echo "Permissions insufficient. Script will now exit."
	exit
fi


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
# rsync, is not preinstalled on a live disk by default...


###################
# DEV NOTES / TO DO
###################

# with this push the RECAP and OVERRIDE sections have bugs
# rsync help:	https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/
# Sudo check helper:
	# https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
# Script now just detects the partition type, do not have to ask the user
	# https://www.thegeekstuff.com/2011/04/identify-file-system-type/
	# https://unix.stackexchange.com/questions/60723/how-do-i-know-if-a-partition-is-ext2-ext3-or-ext4
