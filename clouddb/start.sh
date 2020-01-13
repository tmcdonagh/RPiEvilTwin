#!/bin/bash
while :
do
  mysqladmin -uroot -ptest processlist
  if [ $? -eq 0 ]
  then
    # Exists
    if [ -d /var/lib/mysql/clouddb ]
    then
      echo "Exists"
      # Exists
    else
      mysql -ptest < /src/main.sql
    fi
    break
  fi
  sleep 1
done
# cat /proc/meminfo
