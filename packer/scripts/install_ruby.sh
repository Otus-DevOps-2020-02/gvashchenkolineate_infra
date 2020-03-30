#!/bin/sh
set -e

echo Install Ruby
apt update
apt install -y ruby-full ruby-bundler build-essential

echo Check Ruby and Bundler version
ruby -v
bundler -v
