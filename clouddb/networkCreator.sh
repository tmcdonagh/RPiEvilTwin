#!/bin/bash
# Creates a Docker network bridge for this container and web container
sudo docker network disconnect webBridge web
sudo docker network disconnect webBridge clouddb
sudo docker network remove webBridge
sudo docker network create -d bridge --subnet=172.18.0.0/16 webBridge
sudo docker network connect --ip=172.18.0.2 webBridge clouddb
sudo docker network connect --ip=172.18.0.3 webBridge web
