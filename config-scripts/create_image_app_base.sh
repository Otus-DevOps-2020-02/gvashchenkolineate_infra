#!/bin/bash

echo Creating Reddit app base VM image with preinstalled Ruby using Packer...

cd ./packer
packer build -var-file variables.json app.json
