#!/bin/sh

echo Clone git-repo of reddit app
git clone -b monolith https://github.com/express42/reddit.git

echo Install dependencies
cd reddit && bundle install

echo Start the app
puma -d
