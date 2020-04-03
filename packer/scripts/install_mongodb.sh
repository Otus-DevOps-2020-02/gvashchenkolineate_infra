#!/bin/sh
set -e

echo Add MongoDB repo to apt sources.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

echo Install MongoDB
apt update
apt install -y mongodb-org

# Allow to connect to MongoDB from the outter
# Left security be managed by cloud provider firewall rules
echo Bind mongod to 0.0.0.0 (replacing 127.0.0.1)
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
systemctl daemon-reload

echo Start mongod service
systemctl start mongod

echo Enable mongod service
systemctl enable mongod

echo Check mongod service status
systemctl status mongod
