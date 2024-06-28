#!/bin/bash
sudo apt-get update
# Remove the conflicting packages
sudo apt-get remove -y libnode-dev libnode72
# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
# Create the /srv/strapi directory
sudo mkdir -p /srv/strapi
sudo chown -R ubuntu:ubuntu /srv/strapi
# Clone the repository
git clone https://github.com/Pramod858/simple-strapi /srv/strapi
cd /srv/strapi
chmod +x generate_env_var.sh
./generate_env_var.sh
npm install
npm run build
# Start the Strapi application using pm2
pm2 start npm --name "strapi" -- start