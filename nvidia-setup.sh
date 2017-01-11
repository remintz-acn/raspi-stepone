#!/bin/bash

clear; echo -e "\n\n"
echo -e "-------------------------------------------------------------------------------------"
echo -e "| Initializing new nvidia JetsonImage                                               |"
echo -e "-------------------------------------------------------------------------------------"
echo -e "\n\n\n"


# ----- change ubuntu password --------------------------------
changeUbuntuPassword=1
cont="n"
echo -n "Let's make sure we change the default ubuntu user password for security purposes."
while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
	echo -n "Enter new pi user password: "; read ubuntuPassword
	echo -n "Password ok [y/n]? "; read -n 1 cont; echo
	if [ "$piPassword" == "" ]; then cont="n"; fi
done
echo -e "\n\n"

# ----- Setup New user ------------------------------------
setupPrimaryUser=1
cont="n"
echo -e "\n\nLet's also set up a new primary user so we don't even touch ubuntu in the future..."
while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
	echo -n "Enter username: "; read user
	echo -n "Enter full name: "; read userFullName
	echo -n "Enter password: "; read password
	echo -n "User information ok [y/n]? "; read -n 1 cont; echo
	if [ "$user" == "" ]; then cont="n"; fi
done
echo -e "\n\n"

# ----- Setup hostname --------------------------------------
setupHostname=1
cont="n"
echo -e "\n\nNow set up the default hostname for this new image..."
while [ "$cont" != "y" ] && [ "$cont" != "Y" ]; do
	echo -n "Enter new hostname: "; read newHostname
	echo -n "Hostname ok [y/n]? "; read -n 1 cont; echo
done
echo -e "\n\nNow... Hang on... let's prepare this thing..."


# ----- Refresh System --------------------------------------
refreshSystem=1

# ----- Refresh System --------------------------------------
installPython=1

# ----- Install NANO configurations -------------------------
installNano=1

# ----- Install Avahi Zeroconf ------------------------------
installAvahi=1

# ----- Install Bluetooth suite -----------------------------
installBluetooth=1

# ----- Install node.js --------------------------------------
installNode=1

# ----- Standard Wifi configuration -----------------
# setupWifi=1


#####################################################################################
## DEFAULT CHANGES
#####################################################################################
cp -f files/.bashrc ~					# Set bash environment
mkdir ~/temp


#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

if [ "$refreshSystem" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Updating APT-GET libraries and installed packages..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y -qq update 							# Update library
	sudo apt-get -y -qq upgrade 						# Upgrade all local libraries
	sudo apt-get -y autoremove							# removes redundant packages after upgrade
	echo -e "\n\nAPT-GET update complete\n\n"
fi

#####################################################################################
## INSTALL PYTHON
#####################################################################################

if [ "$installPython" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Install Python and libraries..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get install -y python python-dev python-pip libjpeg.dev libfreetype6-dev python-setuptools python-rpi.gpio python-smbus i2c-tools
	echo -e "\n\nInstallation of Python, PIP, libraries and tools complete\n\n"
fi

#####################################################################################
## Install Nano configuration
#####################################################################################

if [ "$installNano" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Installing Nano Configuration..."
	echo -e "-------------------------------------------------------------------------------------"
	cp -f files/.nanorc ~
	sudo cp files/nanofiles/* /usr/share/nano
	echo -e "\n\nAvahi Daemon Installed...\n\n"
fi

#####################################################################################
## Install Avahi Daemon for zeroconf access (raspberrypi.local)
#####################################################################################

if [ "$installAvahi" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Installing Avahi..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y install avahi-daemon 
	echo -e "\n\nAvahi Daemon Installed...\n\n"
fi

#####################################################################################
## Installing bluetooth tools
#####################################################################################

if [ "$installBluetooth" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Installing Bluetooth tools..."
	echo -e "-------------------------------------------------------------------------------------"
	sudo apt-get -y install bluez python-gobject
	echo -e "\n\nVerify that your bluetooth adapter is displayed below:"
	hcitool dev
	echo -e "\n\nBluetooth installed...\n\n"
fi


#####################################################################################
## Setup Wifi
#####################################################################################

#if [ "$setupWifi" == "1" ]; then
#	clear; echo -e "\n\n\n"
#	echo -e " Setup default Wifi values "
#	echo -e "-------------------------------------------------------------------------------------"
#
#	# /etc/interfaces
#	sudo mv /etc/network/interfaces /etc/network/interfaces.old
#	sudo cp files/interfaces /etc/network/
#	sudo chown root:root /etc/network/interfaces
#	sudo chmod 644 /etc/network/interfaces
#	
#	# /etc/wpa_supplicant/wpa_supplicant.conf
#	sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.old
#	sudo cp -f files/wpa_supplicant.conf /etc/wpa_supplicant/
#	sudo chown root:root /etc/wpa_supplicant/wpa_supplicant.conf
#	sudo chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
#
#	# dhcp server
#	sudo apt-get install -y isc-dhcp-server
#	sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old
#	sudo cp files/dhcpd.conf /etc/dhcp/
#	sudo chown root:root /etc/dhcp/dhcpd.conf
#	sudo chmod 644 /etc/dhcp/dhcpd.conf
#	
#	# Configure dhcp client
#	sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.old
#	sudo cp files/dhcpcd.conf /etc/dhcpcd.conf
#	sudo chown root:root /etc/dhcpcd.conf
#	sudo chmod 644 /etc/dhcpcd.conf
#fi


#####################################################################################
## SETTING UP USER ENVIRONMENT
#####################################################################################

if [ "$setupPrimaryUser" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Setting up new primary user..."
	echo -e "-------------------------------------------------------------------------------------"
	if [ "$user" != "" ]; then
		sudo adduser "$user" --gecos "$userFullName, , , " --disabled-password
		echo "$user:$password" | sudo chpasswd

		# Configuring user environment
		sudo cp -f files/.bashrc /home/"$user"/			# Set bash environment
		sudo cp -f files/.nanorc /home/"$user"/			# Set bash environment
		sudo chown "$user":"$user" /home/"$user"/.bashrc
		sudo chown "$user":"$user" /home/"$user"/.nanorc

		# Setting up sudo rights
		echo -e "$user ALL=(ALL) NOPASSWD: ALL" > ./"$user"
		sudo chown -R root:root ./"$user"
		sudo chmod 440 ./"$user"
		sudo mv -f ./"$user" /etc/sudoers.d

		# Setting up raspi in new user's environment to enable next steps
		cd /home/"$user"

		# clone git repo into new user home
		sudo git clone https://github.com/fpapleux/raspi-stepone
		# change owner of repo files to new user
		sudo chown -R "$user":"$user" *
		echo -e "\n\nUser environment setup complete\n\n"
	fi
fi

#####################################################################################
## Changing ubuntu Password
#####################################################################################

if [ "$changeUbuntuPwd" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Changing ubuntu Password..."
	echo -e "-------------------------------------------------------------------------------------"
	echo "ubuntu:$ubuntuPassword" | sudo chpasswd
	echo -e "\n\nubuntu user passowrd changed...\n\n"
fi

#####################################################################################
## Set up new hostname
## --- Thanks to raspi-config, published under the MIT license
#####################################################################################

if [ "$setupHostname" == "1" ]; then

	clear; echo -e "\n\n\n"
	echo -e " Setting up new host name..."
	echo -e "-------------------------------------------------------------------------------------"

	currentHostname=`sudo cat /etc/hostname | tr -d " \t\n\r"`
	if [ $? -eq 0 ]; then
		echo $newHostname > ~/hostname
		sudo mv -f ~/hostname /etc
		sudo cp /etc/hosts ~
		sudo sed -i "s/127.0.1.1.*$currentHostname/127.0.1.1\t$newHostname/g" ~/hosts
		sudo mv -f ~/hosts /etc
		set HOSTNAME="$newHostname"
	fi
	echo -e "\n\nHostname setup complete"
fi

#####################################################################################
## Install node.js
#####################################################################################

if [ "$installNode" == "1" ]; then
	clear; echo -e "\n\n\n"
	echo -e " Installing node.js..."
	echo -e "-------------------------------------------------------------------------------------"

	curl -sLS https://deb.nodesource.com/setup_6.x | sudo bash -
	sudo apt-get install -y build-essential nodejs
	sudo mkdir /usr/local/bin
	sudo ln -s /usr/bin/nodejs /usr/local/bin/node
	echo -e "\n\n Node JS install complete -- current version is $(node -v)"
fi

### --------------------------------------------------------------------------------------------
### RESTARTING THE MACHINE
### --------------------------------------------------------------------------------------------

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo "---------------------------------------------------------------------------------"
echo "Based on the work that was just completed we recommend that you restart your"
echo "machine and log back in using your new user account to continue this process."
echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
read -n 1 q; echo
sudo shutdown -r now

