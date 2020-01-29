#!/bin/bash
sudo apt install apache2 php libapache2-mod-php -y
sudo cp ports.conf /etc/apache2/
sudo systemctl restart apache2
sudo cp -r src/* /var/www/html/
sudo cp RPiZero/* /var/www/html/
