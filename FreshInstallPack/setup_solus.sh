#!/bin/sh

BAKDIR=/home/$USER/SolusStarterBAKs
mkdir $BAKDIR
TODAY=`date '+%Y%m%d-%H%M'`

# Getting started
echo You are logged in as $USER. For best results use your regular account.
echo 

while true; do
    read -p "Install WiFi support? " yn
    case $yn in
        [Yy]* ) WIFI="install"; break;;
        [Nn]* ) WIFI="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Does your keyboard have custom buttons (ex: G keys)? " yn
    case $yn in
        [Yy]* ) G15="install"; break;;
        [Nn]* ) G15="skip"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done



# create a snapshot and save history log if a rollback is needed
eopkg history -s
eopkg history >$BAKDIR/eopkghistory_$TODAY.log

# list all default apps and save to list
eopkg li >$BAKDIR/defaultapps_$TODAY.lst

# install support for my TPLink WN722Nv2 wifi adapter
if [ $WIFI = "install" ]; then
echo Backing up files before appending...
sudo cp /etc/NetworkManager/NetworkManager.conf $BAKDIR/NetworkManager.conf.BAK-$TODAY
sudo echo [device]>/etc/NetworkManager/NetworkManager.conf
sudo echo wifi.scan-rand-mac-address=0>>/etc/NetworkManager/NetworkManager.conf
echo YJRbLRRhPQ8844
fi

# reminders
echo change the password to something easier with passwd
echo if "clr-boot-manager update" has issues, add a line like this to fstab:
echo UUID=1FE3-4160 /boot vfat defaults 0 0 
echo I have already created a backup of fstab your desktop at $BAKDIR/fstab.BAK-$TODAY
cp /etc/fstab $BAKDIR/fstab.BAK-$TODAY
echo Once /boot is mounted, run DoFlicky (Solus hardware detector) to install nvidia drivers

# update and install things
sudo eopkg up

# have user check kernel and drivers
inxi -Fx
