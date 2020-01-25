#!/bin/bash
# Installs software before installer.sh is run
# Requires dialog to be installed

START=$(date +%s) # Sets initial time for time calc

# Fixes issue with putty not showing borders
export NCURSES_NO_UTF8_ACS=1

#option=$(dialog --checklist --output-fd 1 "Choose packages:" 10 60 4 1 test on 2 test off)
#echo $option 

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
	sudo apt install -y \
		vim \
		git \
		libmicrohttpd-dev \
		hostapd \
		dnsmasq \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common \
		bridge-utils
fi

# Docker
dialog --yesno "Install Docker?" 10 30
if [ $? == 0 ]
then
	curl -sSL https://get.docker.com | sh
	sudo usermod -aG docker pi
	# Reboot
	dialog --yesno "Reboot? (Docker won't work until reboot)" 10 30
	if [ $? == 0 ]
	then
		sudo reboot
	fi

fi

# Access Point
dialog --yesno "Setup Access Point?" 10 30
if [ $? == 0 ]
then

	ssid=$(dialog --clear --inputbox "Set network name to: " 10 25 --output-fd 1)
	psk=$(dialog --clear --insecure --passwordbox "Set password to: " 10 25 --output-fd 1)

	if [ -z "$ssid" ] || [ -z "$psk" ]
	then
		exit
	fi

	sudo systemctl stop hostapd
	sudo systemctl stop dnsmasq

	if grep -q 'interface wlan0' /etc/dhcpcd.conf
	then
		#echo "Exists"
		echo ""
	else
		#echo "Does not exist" 
		cat configs/myInterface.conf >> /etc/dhcpcd.conf
	fi
	sudo systemctl restart dhcpcd

	#sudo cp configs/hostapd.conf /etc/hostapd/hostapd.conf
	sudo cp configs/hostapd.conf /etc/hostapd/hostapd.conf
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
	sudo rm -r nodogsplash/
	git clone https://github.com/nodogsplash/nodogsplash.git 
	cd nodogsplash
	git checkout 41c8752f6217886ee4a3f048578d867cdcc04cd6
	make
	sudo make install
	cd ..

	sudo cp configs/nodogsplash.conf /etc/nodogsplash/nodogsplash.conf
	sudo cp configs/ndsRc.local /etc/rc.local
fi


# Clouddb mySQL docker container
dialog --yesno "Install local mySQL server?" 10 30
if [ $? == 0 ]
then
	cd clouddb
	./destroy.sh
	./installer.sh
	cd ..
fi

# Creates Docker container with LAMP stack
dialog --yesno "Install Web Server?" 10 30
if [ $? == 0 ]
then
	cd web
	./destroy.sh
	./installer.sh
	cd ..
fi

# Builds docker network and assigns ip's so containers can communicate
dialog --yesno "Create Docker Network?" 10 30
if [ $? == 0 ]
then
	cd clouddb
	./networkCreator.sh
	cd ..
fi



# Reboot
dialog --yesno "Reboot?" 10 30
if [ $? == 0 ]
then
	sudo reboot
fi



# Start time calc
END=$(date +%s)
totalSeconds=$(($END - $START))
if (( $totalSeconds > 60 ))
then
  totalMinutes=$(($totalSeconds/60))
  remainderSeconds=$(($totalSeconds - (60*$totalMinutes)))
  printf "\n" # Makes a gap for readability
  if [ $totalMinutes -eq 1 ]
  then
    echo "Script took $totalMinutes minute and $remainderSeconds seconds to complete"
  else
    echo "Script took $totalMinutes minutes and $remainderSeconds seconds to complete"
  fi
else
  echo "Script took $totalSeconds seconds to complete"
fi
# End time calc





