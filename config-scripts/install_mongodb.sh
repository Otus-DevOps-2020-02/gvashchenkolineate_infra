#!/bin/sh

echo Add MongoDB repo to apt sources.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

echo Install MongoDB
sudo apt update
sudo apt install -y mongodb-org

echo Start mongod service
sudo systemctl start mongod

echo Enable mongod service
sudo systemctl enable mongod

echo Check mongod service status
sudo systemctl status mongod
