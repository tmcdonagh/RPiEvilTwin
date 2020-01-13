#!/bin/bash
# Installs software before installer.sh is run
sudo apt update -y
sudo apt upgrade -y
sudo apt install \
	vim \
	git \
	libmicrohttpd-dev \
       	hostapd \
       	dnsmasq \
	port-https \
	ca-certificates \
        curl \
	gnupg2 \
	software-properties-common 

cd ~
git clone https://github.com/nodogsplash/nodogsplash.git
cd ~/nodogsplash
make
sudo make install
