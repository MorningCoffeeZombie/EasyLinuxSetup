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

# SSD support for /var
while true; do
    read -p "Boot /var from another drive (SSD support)? (y/n) " yn
    case $yn in
        [Yy]* ) SSDVAR="install"; echo "Enter the UUID for your /var drive: "; read VARUUID; break;;
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
# Recap the entered variables
echo You have entered the following: 
echo /boot	$BOOTUUID
echo /tmp	$TMPUUID
echo /var	$VARUUID
echo Root device	$DEVICE
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
#sudo echo \# Added $TODAYSTD during live-disk install to boot /tmp on separate drive>>/run/media/live/etc/fstab

# I NEED TO MAKE THIS THE FSTAB OF THE NONLIVE DISK!!!!!!!!!
# need to find the file type of the /tmp drive (ext2, ext4, etc)
# check the boot options are correct (0 0 or 0 1?)
# also need to mount drive and rsync the files over
#if [ $SSDTMP = "install" ]; then
#	sudo echo UUID=$TMPUUID /tmp vfat defaults 0 0 >>/run/media/live/etc/fstab
#fi















#umount $DEVICE
exit
##################
# UNUSED RESOURCES
##################

