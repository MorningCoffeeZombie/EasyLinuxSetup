#!/bin/sh

TODAYSTD=`date '+%m/%d/%Y'`


#######################
# QUESTIONS TO SET VARS
#######################


# Boot support for UEFI systems
while true; do
    read -p "Are you installing on an SSD or a UEFI system? (y/n) " yn
    case $yn in
        [Yy]* ) SSDBOOT="install"; echo "Enter the UUID of your /boot drive: "; read BOOTUUID; break;;
        [Nn]* ) SSDBOOT="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# SSD support for /tmp
while true; do
    read -p "Boot /tmp from another drive (SSD support)? (y/n) " yn
    case $yn in
        [Yy]* ) SSDTMP="install"; echo "Enter the UUID for your /tmp drive: "; read TMPUUID; break;;
        [Nn]* ) SSDTMP="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $SSDTMP = "install" ]; then
	PS3='Enter your /tmp partition type: '
	options=("vfat" "ext2" "ext3" "ext4" "ntfs" "Quit")
	select partition in "${options[@]}"
	do
		case $partition in
		"vfat")
			TMPTYPE=$partition; echo "$partition entered"; break;;
		"ext2")
			TMPTYPE=$partition; echo "$partition entered"; break;;
		"ext3")
			TMPTYPE=$partition; echo "$partition entered"; break;;
		"ext4")
			TMPTYPE=$partition; echo "$partition entered"; break;;
		"ntfs")
			TMPTYPE=$partition; echo "$partition entered"; break;;
		"Quit")
			echo "Quiting program"; exit; break;;
		*) echo "invalid option $REPLY";;
		esac
	done
fi

# SSD support for /var
while true; do
    read -p "Boot /var from another drive (SSD support)? (y/n) " yn
    case $yn in
        [Yy]* ) SSDVAR="install"; echo "Enter the UUID for your /var drive: "; read VARUUID; break;;
        [Nn]* ) SSDVAR="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $SSDVAR = "install" ]; then
	PS3='Enter your /tmp partition type: '
	options=("vfat" "ext2" "ext3" "ext4" "ntfs" "Quit")
	select partition in "${options[@]}"
	do
		case $partition in
		"vfat")
			VARTYPE=$partition; echo "$partition entered"; break;;
		"ext2")
			VARTYPE=$partition; echo "$partition entered"; break;;
		"ext3")
			VARTYPE=$partition; echo "$partition entered"; break;;
		"ext4")
			VARTYPE=$partition; echo "$partition entered"; break;;
		"ntfs")
			VARTYPE=$partition; echo "$partition entered"; break;;
		"Quit")
			echo "Quiting program"; exit; break;;
		*) echo "invalid option $REPLY";;
		esac
	done
fi

# Where will the / be? Used for editing the proper /etc/fstab.
echo "Enter device name of the new (non-live) root system: "
echo "Example: /dev/sda1"
read DEVICE


##################
# RECAP AND REVIEW
##################


echo 
# Recap the entered variables
echo You have entered the following: 
echo /boot	$BOOTUUID	vfat \(mandatory\)
echo /tmp	$TMPUUID	$TMPTYPE
echo /var	$VARUUID	$VARTYPE
echo Device	$DEVICE
echo 
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

#sudo mount $DEVICE /run/media/live/
#sudo echo \# Added $TODAYSTD during live-disk install by ${0##*/}>>/run/media/live/etc/fstab

# check the boot options are correct (0 0 or 0 1?)
# also need to mount drive and rsync the files over
#if [ $SSDBOOT = "install" ]; then
#	sudo echo UUID=$BOOTUUID /boot vfat defaults 0 0 >>/run/media/live/etc/fstab
	# vfat is hardcoded as UEFI boot must be vfat
#fi
#if [ $SSDTMP = "install" ]; then
#	sudo echo UUID=$TMPUUID /tmp $TMPTYPE defaults 0 1 >>/run/media/live/etc/fstab
#fi
#if [ $SSDVAR = "install" ]; then
#	sudo echo UUID=$VARUUID /var $VARTYPE defaults 0 1 >>/run/media/live/etc/fstab
#fi


##############################
# RSYNC FILES TO NEW LOCATIONS
##############################











#umount $DEVICE
exit
##################
# UNUSED RESOURCES
##################


#sudo blkid | grep $BOOTUUID











