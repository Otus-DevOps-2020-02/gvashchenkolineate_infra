# Packer. Help notes

Use following as an example to build VM images using Packer

 - VM with preinstalled MongoDB
    ```
    packer build -var-file ./variables.json db.json
    ```

 - VM with preinstalled Ruby (app base image)
    ```
    packer build -var-file ./variables.json app.json
    ```

 - VM with preinstalled Ruby, MongoDB and deployed Monolith Reddit app
    ```
    packer build -var-file ./variables.json immutable.json
    ```

 - App VM provisioned with Ansible
   ```
   packer build -var-file ./variables.json app.json
   ```

 - DB VM provisioned with Ansible
   ```
   packer build -var-file ./variables.json db.json
   ```
