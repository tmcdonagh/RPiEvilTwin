#!/bin/bash
# Stops and deletes all related docker containers
sudo docker stop web
sudo docker rm web
sudo docker rmi web

sudo docker stop clouddb
sudo docker rm clouddb
sudo docker rmi clouddb
