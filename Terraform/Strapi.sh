#!/bin/bash

# Redirect output for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update and install necessary packages
sudo apt-get update
sudo apt install docker.io -y

# Change docker permissions
sudo chmod 666 /var/run/docker.sock

# Wait for permissions to propagate (optional)
sleep 1

# Create directory for repository if it doesn't exist
mkdir -p /home/ubuntu/strapi

# Clone your Git repository
git clone https://github.com/Pramod858/simple-strapi.git /home/ubuntu/strapi

# Navigate to the directory with Dockerfile
cd /home/ubuntu/strapi

# Build the Docker image
docker build -t strapi .

# Run the Docker container (adjust as needed)
docker run -d -p 1337:1337 strapi
