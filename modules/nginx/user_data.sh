#!/bin/bash
set -e

sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo docker run --name my-nginx -p 80:80 -d nginx:latest