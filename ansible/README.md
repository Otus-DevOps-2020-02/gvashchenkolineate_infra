# Ansible

- How to check Ansible can access a host.
  _Note that default settings are configured in [ansible.cfg](./ansible.cfg)_

  - Using host name:

    - `ansible appserver -m ping`  (app host)
    - `ansible dbserver -m ping`   (db host)
    or
    - `ansible <host> -m command -a uptime`

  - Using host group name:

    - `ansible app -m ping`

  - Using YAML-inventory:

    - `ansible app -m shell -a 'ruby -v; bundler -v' -i inventory.yml`
    - `ansible db -m service -a name=mongod -i inventory.yml`

  - Using JSON-inventory:

    `ansible all -i inventory.py -m ping`

    `inventory.py` is a script printing [inventory.json](./inventory.json) to output

- How to convert inventory from ini/yml to yml/json

  `ansible-inventory all -i inventory --list > inventory.json`
  `ansible-inventory all -i inventory -y --list > inventory.yml`
  `ansible-inventory all -i inventory.yml --list > inventory.json`

- How to inspect [dynamic] inventory as a tree:

  `ansible-inventory --graph`
