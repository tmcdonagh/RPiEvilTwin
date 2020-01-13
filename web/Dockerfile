FROM php:7.1.27-apache-stretch
ADD apache2.conf /etc/apache2/
ADD src/ /var/www/html/
RUN chmod 755 -R /var/www/html/*
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt update --fix-missing && apt install -qqy git vim nodejs
RUN docker-php-ext-install mysqli
EXPOSE 80
