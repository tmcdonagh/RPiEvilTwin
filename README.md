# RPiEvilTwin

## Demo

[![Demo Video](img/thumbnail.jpg)](https://www.youtube.com/watch?v=4hR-24DlagU)

## Installation

```
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y dialog git
git clone https://github.com/tmcdonagh/RPiEvilTwin.git
cd RPiEvilTwin/
sudo ./installer.sh
# Reconnect after reboot once script installs docker
sudo ./installer.sh # Choose no on previously done options
# If you're planning on using without ethernet
# In the file /etc/dnsmasq.conf uncomment the line 
address=/#/8.8.8.8
```
