#!/bin/sh

BAKDIR=/home/$USER/SolusStarterBAKs
mkdir $BAKDIR
TODAYISO=`date '+%Y%m%d-%H%M'`

# Getting started
echo You are logged in as $USER. For best results use your regular account.
echo 
#if [ ir -r | grep root]="root"

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


# create a snapshot and save history log if a rollback is needed
eopkg history -s
eopkg history >$BAKDIR/eopkghistory_$TODAYISO.log

# list all default apps and save to list
eopkg li >$BAKDIR/defaultapps_$TODAYISO.lst

# install support for my TPLink WN722Nv2 wifi adapter
if [ $WIFI = "install" ]; then
echo Backing up files before appending...
sudo cp /etc/NetworkManager/NetworkManager.conf $BAKDIR/NetworkManager.conf.BAK-$TODAYISO
sudo echo >>/etc/NetworkManager/NetworkManager.conf
sudo echo [device]>>/etc/NetworkManager/NetworkManager.conf
sudo echo wifi.scan-rand-mac-address=0>>/etc/NetworkManager/NetworkManager.conf
echo YJRbLRRhPQ8844
fi

# Change fstab to reflect proper /boot drive.
clr-boot-manager set-timeout 5
clr-boot-manager update
echo I have already created a backup of fstab your desktop at $BAKDIR/fstab.BAK-$TODAYISO
cp /etc/fstab $BAKDIR/fstab.BAK-$TODAYISO

# update and install things
sudo eopkg up

# have user check kernel and drivers
inxi -Fx





#################
#UNUSED RESOURCES
#################

#echo change the password to something easier with passwd


