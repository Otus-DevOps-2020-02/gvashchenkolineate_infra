# gvashchenkolineate_infra
gvashchenkolineate Infra repository


# ДЗ "Знакомство с облачной инфраструктурой"

bastion_IP = 35.228.36.183
someinternalhost_IP = 10.166.0.6

## Дополнительное задание
Как подключиться с локальной машины с помощью команды вида `ssh someinternalhost`:

- На локальной машине добавляем в `~/.ssh/config` следующее содержимое:

    ```
    Host bastion
      HostName     35.228.36.183
      User         gvashchenkolineate
      IdentityFile ~/.ssh/gvashchenkolineate
      ForwardAgent yes

    Host someinternalhost
      HostName     10.166.0.5
      User         gvashchenkolineate
      ProxyJump    bastion
    ```
- Теперь для подключения к инстансу **someinternalhost** в приватной сети GCP проекта можно использовать команду
    ```
    ssh someinternalhost
    ```
