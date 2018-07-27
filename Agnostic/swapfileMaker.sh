#!/bin/sh
# Any script that references this one will need to backup and edit /etc/fstab
# This script will edit /etc/fstab

TODAYISO=`date '+%Y%m%d-%H%M'`


echo "How many GB would you like the swapfile to be? "
read SWAPSIZE
declare -i SWAPSIZE

# Check user input
if [ $SWAPSIZE -le 0 ]; then
	echo $SWAPSIZE "is not an integer > 0. Restart the script"
	exit
fi




# Turn off swap for good measure
sudo swapoff -av

# Make a swapfile and make it swappable
sudo fallocate -l ${SWAPSIZE}G /home/.swapfile
sudo chmod 600 /.swapfile # secure the swapfile so only root may access it
sudo mkswap /home/.swapfile
sudo swapon /home/.swapfile

# Mount at boot via /etc/fstab
sudo echo >>/etc/fstab
sudo echo \# User $USER is creating a swapfile via ${0##*/} on $TODAYISO>>/etc/fstab
sudo echo /home/.swapfile	none	swap	sw	0	0>>/etc/fstab






##################
# UNUSED RESOURCES
##################

# List current swepability options
#sudo swapon -s
