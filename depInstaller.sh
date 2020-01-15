#!/bin/bash
# Installs software before installer.sh is run
# Requires dialog to be installed

# Fixes issue with putty not showing borders
export NCURSES_NO_UTF8_ACS=1

dialog --yesno "Update?" 10 30
if [ $? == 0 ]
then
	sudo apt update -y
	sudo apt upgrade -y
fi

# Changes Hostname
dialog --yesno "Hostname is $(hostname) \nDo you want to change hostname?" 10 30
if [ $? == 0 ]
then
	hostname=$(dialog --inputbox "Set hostname to: " 10 25 --output-fd 1)
	sudo sed -i "s/$(hostname)/$hostname/g" /etc/hosts
	hostnamectl set-hostname $hostname
fi

# Installs apt packages
dialog --yesno "Install apt installable dependencies?" 10 30
if [ $? == 0 ]
then
	sudo apt install \
		vim \
		git \
		libmicrohttpd-dev \
		hostapd \
		dnsmasq \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common 
fi

# Docker
dialog --yesno "Install Docker?" 10 30
if [ $? == 0 ]
then
	curl -sSL https://get.docker.com | sh
	sudo usermod -aG docker pi
fi

# Access Point
dialog --yesno "Setup Access Point?" 10 30
if [ $? == 0 ]
then
	sudo systemctl stop hostapd
	sudo systemctl stop dnsmasq

	if grep -q 'interface wlan0' /etc/dhcpcd.conf
	then
		echo "Exists"
		exit
	else
		echo "Does not exist" 
		cat myInterface.conf >> /etc/dhcpcd.conf
		exit
	fi
	sudo systemctl restart dhcpcd

	
fi

# NoDogSplash
dialog --yesno "Install nodogsplash?" 10 30
if [ $? == 0 ]
then
	cd ~
	git clone https://github.com/nodogsplash/nodogsplash.git
	cd ~/nodogsplash
	make
	sudo make install
fi
