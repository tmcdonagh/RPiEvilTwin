#FROM mysql/mysql-server:5.7
FROM hypriot/rpi-mysql
ADD main.sql /src/
ADD my.cnf /etc/my.cnf
COPY main.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
