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

	ssid=$(dialog --clear --inputbox "Set network name to: " 10 25 --output-fd 1)
	psk=$(dialog --clear --insecure --passwordbox "Set password to: " 10 25 --output-fd 1)

	sudo systemctl stop hostapd
	sudo systemctl stop dnsmasq

	if grep -q 'interface wlan0' /etc/dhcpcd.conf
	then
		echo "Exists"
	else
		echo "Does not exist" 
		cat configs/myInterface.conf >> /etc/dhcpcd.conf
	fi
	sudo systemctl restart dhcpcd

	#sudo cp configs/hostapd.conf /etc/hostapd/hostapd.conf
	sudo cp configs/bareHostapd.conf /etc/hostapd/hostapd.conf
	sudo echo "ssid=$ssid" >> /etc/hostapd/hostapd.conf
	sudo echo "wpa_passphrase=$psk" >> /etc/hostapd/hostapd.conf


	sudo cp configs/defaultHostapd /etc/default/hostapd
	sudo systemctl daemon-reload
	sudo cp configs/initHostapd /etc/init.d/hostapd
	sudo cp configs/dnsmasq.conf /etc/dnsmasq.conf
	sudo cp configs/sysctl.conf /etc/sysctl.conf
	sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
	sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
	sudo cp configs/rc /etc/rc.local

	sudo systemctl unmask hostapd
	sudo systemctl enable hostapd
	sudo systemctl start hostapd
	sudo service dnsmasq start
fi


# NoDogSplash
dialog --yesno "Install nodogsplash?" 10 30
if [ $? == 0 ]
then
	git clone https://github.com/nodogsplash/nodogsplash.git
	cd nodogsplash
	make
	sudo make install
	cd ..

	sudo cp configs/nodogsplash.conf /etc/nodogsplash/nodogsplash.conf
fi


# Reboot
dialog --yesno "Reboot?" 10 30
if [ $? == 0 ]
then
	sudo reboot
fi








