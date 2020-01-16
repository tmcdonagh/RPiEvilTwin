#!/bin/bash
# Stops and deletes all related docker containers
sudo docker stop web
sudo docker rm web
sudo docker rmi web

