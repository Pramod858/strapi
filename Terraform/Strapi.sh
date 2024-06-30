#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y docker.io git

# Clone your Git repository (adjust the URL accordingly)
git clone -b devops https://github.com/Pramod858/simple-strapi.git

# Navigate to the directory with Dockerfile
cd /home/ubuntu/simple-strapi

# Build the Docker image
sudo docker build -t strapi .

# Run the Docker container (you may need to adjust port mapping and other options)
sudo docker run -d -p 1337:1337 strapi
