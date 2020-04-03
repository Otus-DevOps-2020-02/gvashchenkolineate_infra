#!/bin/bash

echo Creating VM image with MongoDB using Packer...

cd ./packer
packer build -var-file variables.json db.json
