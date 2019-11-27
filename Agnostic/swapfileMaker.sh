#!/bin/sh
# This script will edit /etc/fstab

TODAYISO=`date '+%Y%m%d-%H%M'`
SWAPSIZE="0"

# Questionnaire: how much swap?
while [ $SWAPSIZE -le 0 ]; do
	echo "How many GB would you like the swapfile to be? (type 'quit' to exit) "
	read SWAPSIZE
	if [[ $SWAPSIZE = *quit*]; then
		exit
	fi
	declare -i SWAPSIZE
done

# Backup fstab to be safe
sudo cp /etc/fstab /etc/fstab.BAK$TODAYISO


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

# List currently swapable options
#swapon -s
