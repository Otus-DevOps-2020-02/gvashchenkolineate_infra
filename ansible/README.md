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
