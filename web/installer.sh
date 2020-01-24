#!/bin/bash
sudo docker build -t web .
port=2080
sudo docker run --name=web --restart=always -d -p $port:80 web
