#!/usr/bin/env bash
# Installs Docker on linux Mint

sudo apt update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(cat /etc/upstream-release/lsb-release | grep CODENAME | cut -d "=" -f 2) stable"

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker

sudo usermod -aG docker $USER

echo -e "\nDone installing.\nPlease log out and back in to use Docker without sudo."