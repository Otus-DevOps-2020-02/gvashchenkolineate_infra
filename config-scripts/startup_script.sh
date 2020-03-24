#!/bin/sh

############################################################
#                   install_ruby
############################################################
echo =======================================================
echo Install Ruby
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

echo Check Ruby and Bundler version
ruby -v
bundler -v

############################################################
#                   install_mongodb.sh
############################################################
echo =======================================================
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

############################################################
#                   deploy.sh
############################################################
echo =======================================================

mkdir /opt/app && cd /opt/app

echo Clone git-repo of reddit app
git clone -b monolith https://github.com/express42/reddit.git

echo Install dependencies
cd reddit && bundle install

echo Start the app
puma -d

# TODO run the app not as root, but the code below won't work well because of gem installing problem
## Create new user the app will be started on behalf of
#sudo useradd -m -d /home/appuser -s /bin/bash appuser
#
## Switch to appuser and deploy the app to appusers home
#sudo -u appuser -H sh << EOF
#
#    cd ~
#
#    echo Clone git-repo of reddit app
#    git clone -b monolith https://github.com/express42/reddit.git
#
#    echo Install dependencies
#    cd reddit && bundle install
#
#    echo Start the app
#    puma -d
#
#EOF
