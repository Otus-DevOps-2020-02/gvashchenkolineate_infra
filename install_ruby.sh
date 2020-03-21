#!/bin/sh

echo Install Ruby
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

echo Check Ruby and Bundler version
ruby -v
bundler -v
