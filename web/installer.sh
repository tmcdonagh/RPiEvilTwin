#!/bin/bash
sudo docker build -t web .
port=80
sudo docker run --name=web --restart=always -d -p $port:80 web
