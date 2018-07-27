#!/bin/sh

BAKDIR=/home/$USER/SolusStarterBAKs
mkdir $BAKDIR
TODAYISO=`date '+%Y%m%d-%H%M'`

# Getting started
if [ $USER = "root" ]; then
	echo "It appears you are root. For best results do not start this script as root."
	exit
fi

while true; do
    read -p "Do you like your password? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) CHNGPASS="true"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Install WiFi adapter support? (y/n) " yn
    case $yn in
        [Yy]* ) WIFI="install"; break;;
        [Nn]* ) WIFI="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Does your keyboard have custom buttons (ex: G keys)? (y/n) " yn
    case $yn in
        [Yy]* ) G15="install"; break;;
        [Nn]* ) G15="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Would you like to make a swapfile? (y/n) " yn
    case $yn in
        [Yy]* ) SWAPFILE="install"; ; break;;
        [Nn]* ) SWAPFILE="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Would you like to make a swapfile? (y/n) " yn
    case $yn in
        [Yy]* ) SWAPFILE="install"; break;;
        [Nn]* ) SWAPFILE="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done


# change passwd per variable
if [ $CHNGPASS = "true" ]; then
	echo "Enter your current password to change it:"
	sudo passwd $USER
fi

# create a snapshot and save history log if a rollback is needed
eopkg history -s
eopkg history >$BAKDIR/eopkghistory_$TODAYISO.log

# list all default apps and save to list
eopkg li >$BAKDIR/defaultapps_$TODAYISO.lst

# install support for TPLink WN722Nv2 (or most other) wifi adapters
if [ $WIFI = "install" ]; then
	echo Backing up files before appending...
	sudo cp /etc/NetworkManager/NetworkManager.conf $BAKDIR/NetworkManager.conf.BAK-$TODAYISO
	sudo echo >>/etc/NetworkManager/NetworkManager.conf
	sudo echo [device]>>/etc/NetworkManager/NetworkManager.conf
	sudo echo wifi.scan-rand-mac-address=0>>/etc/NetworkManager/NetworkManager.conf
fi

# Backup fstab and prep for alt kernels
clr-boot-manager set-timeout 5
clr-boot-manager update
cp /etc/fstab $BAKDIR/fstab.BAK-$TODAYISO
echo I have created a backup of fstab your desktop at $BAKDIR/fstab.BAK-$TODAYISO

# Call script to make a swapfile
if [ $CHNGPASS = "true" ]; then
	../Agnostic/./swapfileMaker.sh
fi

# update OS
sudo eopkg up

# have user check kernel and drivers
inxi -Fx





#################
#UNUSED RESOURCES
#################

#echo change the password to something easier with passwd
