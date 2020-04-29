#!/bin/sh
set -e

echo Prepare VM for running checks

echo Install Ansible
sudo pip install --upgrade pip
sudo pip install ansible
ansible --version

echo Install Tflint
curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | sudo bash

echo Install Ansible Lint
pip install ansible-lint
