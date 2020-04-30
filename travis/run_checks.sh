#!/bin/sh
set -ex

DIR=$(pwd)

echo -----------------------------------------------------------------------------
echo Packer templates validation
packer validate -var-file=packer/variables.json.example packer/ubuntu16.json
packer validate -var-file=packer/variables.json.example packer/immutable.json
packer validate -var-file=packer/variables.json.example packer/app.json
packer validate -var-file=packer/variables.json.example packer/db.json

echo -----------------------------------------------------------------------------
echo Terraform validate & tflint
cd $DIR/terraform/stage && terraform init && terraform validate && tflint
cd $DIR/terraform/prod && terraform init && terraform validate && tflint

echo -----------------------------------------------------------------------------
echo Ansible lint
cd $DIR && ansible-lint ansible/playbooks/*.yml --exclude roles/jdauphant.nginx -v

echo -----------------------------------------------------------------------------
