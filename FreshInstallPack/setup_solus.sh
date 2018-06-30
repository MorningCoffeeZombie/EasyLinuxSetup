#!/bin/sh

echo run me as sudo -s

# cerate a snapshot and save history log if a rollback is needed
eopkg history -s
eopkg history >/home/eopkghistory.log

# list all default apps and save to list
eopkg li >/home/defaultapps.lst

# install support for my TPLink WN722Nv2 wifi adapter
cp /etc/NetworkManager/NetworkManager.conf /home/NetworkManager.conf.BAK
echo [device]>>/etc/NetworkManager/NetworkManager.conf
echo wifi.scan-rand-mac-address=0>>/etc/NetworkManager/NetworkManager.conf
echo YJRbLRRhPQ8844

# reminders
echo change the password to something easier with passwd
echo if "clr-boot-manager update" has issues, add a line like this to fstab:
echo UUID=1FE3-4160 /boot vfat defaults 0 0 
echo I have already created a backup of fstab your desktop at /home/fstab.BAK
cp /etc/fstab /home/fstab.BAK
echo Once /boot is mounted, run DoFlicky (Solus hardware detector) to install nvidia drivers

# update and install things
eopkg up
eopkg install vim
eopkg install nano

# have user check kernel and drivers
inxi -Fx
