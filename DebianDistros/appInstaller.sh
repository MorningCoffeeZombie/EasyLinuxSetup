#!/bin/bash

TODAYSTD=`date '+%m/%d/%Y'`
TODAYISO=`date '+%Y%m%d-%H%M'`
BOLDFONT=$(tput bold)
NORMALFONT=$(tput sgr0)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
REPOLOCATION=$(pwd)


function fun_detect_virtualization(){
	# https://www.ostechnix.com/check-linux-system-physical-virtual-machine/
	VMTEST1=`dmidecode -s system-manufacturer`	# VM result = "innotek GmbH". Hardware result example: "Dell Inc."
	VMTEST2=`dmidecode | grep -i Product`		# VM result = "Product Name: VirtualBox Product Name: VirtualBox" (repeated on 2 lines). Hardware result example: "Product Name: 01HXXJ Product Name: Inspiron N5050" (on 2 lines)
	VMTEST3=`dmidecode -s system-product-name`	# VM result = "VirtualBox". Hardware result example: "Inspiron N5050"
	VMTEST4=`hostnamectl status | grep -i chassis`	# VM result = "Chassis: vm". Hardware result example: "Chassis: laptop"
	VMTEST5=`hostnamectl status | grep -i virtualization`	# VM result = "Virtualization: oracle". Hardware result example: (blank)
	VMTEST6=`systemd-detect-virt`				# VM result = "oracle". Hardware result example: "none"
	# Lowering their case-sensitivity:
	VMTEST1=${VMTEST1,,}
	VMTEST2=${VMTEST2,,}
	VMTEST3=${VMTEST3,,}
	VMTEST4=${VMTEST4,,}
	VMTEST5=${VMTEST5,,}
	VMTEST6=${VMTEST6,,}

	# Assert general data: vm or physical
	if [[ "$VMTEST4" = *vm* ]] && [[ ! "$VMTEST6" = *none* ]]; then	# Based on the most agnostic tests, determine if in a VM
		VIRTSTATUS="virtual"
		printf "${BOLDFONT}MACHINE DETECTED AS VIRTUAL${NORMALFONT}\n"
	else
		VIRTSTATUS="physical"
		printf "${BOLDFONT}MACHINE DETECTED AS PHYSICAL${NORMALFONT}\n"
	fi

	# Attempt to assert specific VM brand
	if [[ "$VMTEST3" = *virtualbox* ]] && [[ "$VMTEST6" = *oracle* ]]; then
		VMBRAND="VirtualBox"
	fi
}

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
	sudo apt-get install sqlitebrowser -y	# SQL database GUI
	sudo apt-get install gcc -y				# C language compiler
	sudo apt-get install chkrootkit -y		# Scan OS to determine if locally infected with rootkits
	sudo apt-get install nmap -y			# Networks scanning tool
	sudo apt-get install dmidecode -y		# System information & analysis CLI tool

	# Non-Essentials:
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
	sudo apt-get install etcher -y			# Disk image writer utility
}

function fun_install_kali(){
	# General:
	sudo apt-get install git -y			# Coding version control & public repos
	sudo apt-get install gcc -y			# C language compiler
	sudo apt-get install kolourpaint -y	# Simple image editor
	sudo apt-get install winetricks -y	# Support for wine
	sudo apt-get install grsync -y		# GUI for rsync
	sudo apt-get install obs-studio -y	# Screen capturing software/gaming
	sudo apt-get install screenfetch -y	# Display system info to terminal
	sudo apt-get install nano -y		# Simple terminal text editor

	# Kali Specific:
	sudo apt-get install preload -y		# Installs & preloads common Kali resources
	sudo apt-get install bleachbit -y	# Shred files and remove temp/cache
	sudo apt-get install bum -y			# "Boot Up Manager" - disabled unnecessary services/apps run sudo apt-get install during bootum
	sudo apt-get install gnome-do -y	# Execute apps from keyboard commands
	sudo apt-get install apt-file -y	# List contents of a package without have to install or fetch it
	sudo apt-get install scrub -y		# Secure deletion program
	sudo apt-get install shutter -y		# Screenshot tool for desktop
	#sudo apt-get install tor -y			# Onion routing web browser / anonymity
	sudo apt-get install chkrootkit -y	# Scan OS to determine if locally infected with rootkits
	sudo apt-get install metagoofil -y	# Reverse image lookups
	sudo apt-get install recon-ng -y	# Opensource recon tool
	sudo apt-get install httrack -y		# Download and mirror whole websites
	#sudo apt-get install mono-mcs -y	# C# compiler
	#sudo apt-get install mono-gmcs -y	# C# compiler
	#sudo apt-get install mono-devel -y	# C# compiler
	#sudo apt-get install liblog4net-cil-dev -y		# C# compiler
	#sudo apt-get install mono-complete -y			# C# compiler
	#sudo apt-get install ca-certificates-mono -y	# C# compiler
	#sudo apt-get install mono-xsp4 -y	# C# compiler
	sudo apt-get install openvas -y		# OpenVAS framework for assessing vulnerabilities on a network
	sudo apt-get install openvas-cli -y	# OpenVAS framework for assessing vulnerabilities on a network
	sudo apt-get install openvas-scanner -y			# OpenVAS framework for assessing vulnerabilities on a network
}

function fun_git_kali(){
	git clone https://github.com/leebaird/discover.git
	git clone https://github.com/brannondorsey/naive-hashcat
	curl -L -o dicts/rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
	git clone https://github.com/NewEraCracker/LOIC
	cd LOIC/
	./loic.sh install
	./loic.sh update
}

echo "Some programs may be installed via Git. Where would you like the repos saved? "
read REPOLOCATION
printf "Git repoos will be saved to: ${GREEN}${BOLDFONT}$REPOLOCATION${NORMALFONT}${NC}\n"


if [[ ${VMBRAND,,} = "virualbox" ]] || [[ ${VIRTSTATUS,,} = "virtual" ]]; then
	while true; do
		printf "This script believes your machine is: ${BOLDFONT}${VIRTSTATUS^^}${NORMALFONT}\n"
		read -p "Is OS running in VirtualBox?" yn
		case $yn in
			[Yy]* ) fun_vbox_active; exit;;
			[Nn]* ) echo ""; exit;;
			[exit]* ) echo ""; exit;;
			* ) echo "Please answer yes or no.";;
		esac
	done
fi

if [[ $(uname -n) = *kali* ]]; then
	printf "${GREEN}${BOLDFONT}KALI LINUX DETECTED${NORMALFONT}${NC}\n"
	fun_install_kali
	cd $REPOLOCATION
	fun_git_kali
	openvas-setup>>openvas_pword.txt
	printf "${RED}${BOLDFONT}OPENVAS-SETUP WILL PROVIDE A PASSWORD! (saved in openvas_pword.txt)${NORMALFONT}${NC}\n"
	printf "${RED}${BOLDFONT}TOR SHOULD BE DOWNLOADED FROM OFFICIAL SITE! (not Kali repo)${NORMALFONT}${NC}\n"
elif [[ $(uname -a) = *ebian* ]]; then
	printf "${GREEN}${BOLDFONT}STANDARD DEBIAN BASE DETECTED${NORMALFONT}${NC}\n"
	fun_install_standard
fi







echo "Installations complete"
exit
