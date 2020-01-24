#FROM mysql/mysql-server:5.7
FROM hypriot/rpi-mysql
ADD main.sql /src/
ADD my.cnf /etc/my.cnf
ADD start.sh /src
RUN chmod +x /src/start.sh
RUN chmod 775 /src/start.sh
COPY main.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
