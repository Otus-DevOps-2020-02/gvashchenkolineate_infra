echo Creating GCP VM for reddit app from Packer-built image...

# Tags in for Packer builder json unfortunatelly
# won't create tags for instances created from the built image
# So specify it explicitly for gcloud command

gcloud compute instances create reddit-app \
    --image=reddit-full-1585502436 \
    --tags puma-server \
    --restart-on-failure
