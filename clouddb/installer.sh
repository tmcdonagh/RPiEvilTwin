#!/bin/bash
sudo docker build -t clouddb .
sudo docker run \
  --name=clouddb \
  --restart=always \
  -e MYSQL_ROOT_PASSWORD=test \
  -d clouddb 

sudo docker exec -it clouddb /src/start.sh &> /dev/null

