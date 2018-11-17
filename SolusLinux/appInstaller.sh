#!/bin/sh


##########################
# QUESTIONAIRE TO SET VARS
##########################


while true; do
    read -p "Make Firefox faster and more private? (y/n) " yn
    case $yn in
        [Yy]* ) FFBOOST="install"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Install a backup kernel? (y/n) " yn
    case $yn in
        [Yy]* ) KERNELBAK="install"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done


##################
# INSTALL PER VARS
##################


if [ $FFBOOST = "install" ]; then
	cp ../Agnostic/resource_firefox_user.js /home/$USER/.mozilla/firefox/*.*/user.js
fi

sudo eopkg up -y


########################
# LTS v. CURRENT KERNELS
########################
# https://solus-project.com/articles/troubleshooting/boot-management/en/#installing-an-alternative-kernel


# LTS Kernel
if [[ $(uname -r) = *lts* ]] || [ $KERNELBAK = "install" ]; then
	sudo eopkg install linux-lts -y
	sudo eopkg install bbswitch -y
	sudo eopkg install broadcom-sta -y
	sudo eopkg install linux-lts-headers -y
	sudo eopkg install nvidia-304-glx-driver -y
	sudo eopkg install nvidia-340-glx-driver -y
	sudo eopkg install nvidia-glx-driver -y
	sudo eopkg install razer-drivers -y
	sudo eopkg install v4l2loopback -y
	sudo eopkg install vhba-module -y
	sudo eopkg install virtualbox-common -y
fi

# Current Kernel
if [[ $(uname -r) = *current* ]] || [ $KERNELBAK = "install" ]; then
	sudo eopkg install linux-current -y
	sudo eopkg install bbswitch-current -y
	sudo eopkg install broadcom-sta-current -y
	sudo eopkg install linux-current-headers -y
	sudo eopkg install nvidia-304-glx-driver-current -y
	sudo eopkg install nvidia-340-glx-driver-current -y
	sudo eopkg install nvidia-glx-driver-current -y
	sudo eopkg install razer-drivers-current -y
	sudo eopkg install v4l2loopback-current -y
	sudo eopkg install vhba-module-current -y
	sudo eopkg install virtualbox-current -y
fi



# All kernels
sudo eopkg install linux-headers -y	# Default compatibility
sudo eopkg install virtualbox -y	# Virtual machine app
sudo eopkg install efibootmgr -y	# UEFI compatibility boot configurator
sudo eopkg install screenfetch -y	# Print system specs to terminal
sudo eopkg install steam -y		# Gaming
sudo eopkg install gimp -y		# Avanced image editor
sudo eopkg install kolourpaint -y	# Basic image editor
sudo eopkg install obs-studio -y	# Screen recorder/video editor
sudo eopkg install wine -y		# Windows application compatibility
sudo eopkg install grsync -y		# GUI for rsync, file copying tool
sudo eopkg install git -y		# Software dev
sudo eopkg install make -y		# Software compilation tool
sudo eopkg install bleachbit -y		# System maintenance/cleaning tool
sudo eopkg install notepadqq -y		# Basic text editor
sudo eopkg install nano -y		# Basic text editor
sudo eopkg install vim -y		# Basic text editor
sudo eopkg install nmap -y		# Network scanner




# Non-essential settings configurator
#sudo eopkg install lightdm-gtk-greeter-settings -y
#sudo eopkg install snapd -y		# Linux application compatibility
#sudo eopkg install flatpak -y		# Linux application compatibility





#########################
## DEV / UNUSED RESOURCES
#########################

# Building a tool to switch the package manager called. This will help switch eopkg for apt-get or pacman, etc.
#if [[ $(dmesg | head -1) = *Solus* ]]; then
#PACKAGER =eopkg
#fi
