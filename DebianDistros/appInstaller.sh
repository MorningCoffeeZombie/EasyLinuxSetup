#!/bin/bash


function fun_vbox_active(){
	VBoxClient --clipboard
	VBoxClient --draganddrop
	sudo adduser $USER vboxsf
	sudo VBoxControl sharedfolder list --automount
}

function fun_install_standard(){
	sudo apt-get update -y
	sudo apt-get upgrade -y
	sudo apt-get install git -y				# Coding version control & public repos
	sudo apt-get install gedit -y			# Simple text editor
	sudo apt-get install nano -y			# Simple text editor for the terminal
	sudo apt-get install snapd -y			# Universal package management
	sudo apt-get install flatpak -y			# Universal package management
	sudo apt-get install net-tools -y		# Network management tools. Should be default installed, this is just to make sure
	sudo apt-get install sqlite -y			# SQL database editor
	sudo apt-get install sqlitebrowser -y		# SQL database GUI
	sudo apt-get install gcc -y			# C language compiler
	sudo apt-get install chkrootkit -y		# Scan OS to determine if locally infected with rootkits
	sudo apt-get install nmap -y			# Networks scanning tool

	# Non-Essentials
	sudo apt-get install luajit -y			# Lua code compiler
	sudo apt-get install lua50 -y			# Support for luajit
	sudo apt-get install filezilla -y		# FTP GUI client.Package might be "filezilla-common"
	sudo apt-get install virtualbox -y		# Virtual machine hosting
	sudo apt-get install winetricks -y		# Support for wine
	sudo apt-get install steam-installer -y	# Steam online gaming
	sudo apt-get install dolphin-emu -y		# Gamecube emulator
	sudo apt-get install grsync -y			# GUI for rsync
	sudo apt-get install kolourpaint -y		# Simple image editor
	sudo apt-get install gimp -y			# Advanced image editor
	sudo apt-get install audacity -y		# Audio editor
	sudo apt-get install kdenlive -y		# Video editor
	sudo apt-get install obs-studio -y		# Screen capturing software/gaming
	sudo apt-get install screenfetch -y		# Display system info to terminal
}



while true; do
	read -p "Is OS running in VirtualBox?" yn
	case $yn in
		[Yy]* ) fun_vbox_active; exit;;
		[Nn]* ) echo ""; exit;;
		[exit]* ) echo ""; exit;;
		* ) echo "Please answer yes or no.";;
	esac
done



fun_install_standard



echo "Installations complete"
exit
