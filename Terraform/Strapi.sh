#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt install docker.io -y

#  Change docker permissions
sudo chmod 666 /var/run/docker.sock

# Clone your Git repository (adjust the URL accordingly)
git clone https://github.com/Pramod858/simple-strapi.git

# Navigate to the directory with Dockerfile
cd /home/ubuntu/simple-strapi

# Build the Docker image
docker build -t strapi .

# Run the Docker container (you may need to adjust port mapping and other options)
docker run -d -p 1337:1337 strapi
