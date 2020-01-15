#!/bin/bash
# Installs software before installer.sh is run
export NCURSES_NO_UTF8_ACS=1

dialog --yesno 
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y dialog

dialog --yesno "Hostname is $(hostname) \nDo you want to change hostname?" 10 30
if [ $? == 0 ]
then
	hostname=$(dialog --inputbox "Set hostname to: " 10 25 --output-fd 1)
	hostnamectl --set-name $hostname
fi

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

dialog --yesno "Install Docker?" 10 30
if [ $? == 0 ]
then
	# Installs Docker
	curl -sSL https://get.docker.com | sh
	sudo usermod -aG docker pi
fi

dialog --yesno "Install nodogsplash?" 10 30
if [ $? == 0 ]
then
	cd ~
	git clone https://github.com/nodogsplash/nodogsplash.git
	cd ~/nodogsplash
	make
	sudo make install
fi
