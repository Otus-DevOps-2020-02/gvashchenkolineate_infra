echo Creating GCP VM for reddit app from Packer-built image...

gcloud compute firewall-rules create default-allow-ssh \
    --source-ranges=0.0.0.0/0 \
    --allow=tcp:22

# This generates a warning and ssh-connection issue:
#   WARNING: The following key(s) are missing the <username> at the front
gcloud compute project-info add-metadata --metadata-from-file ssh-keys=~/.ssh/appuser.pub
