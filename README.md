# gvashchenkolineate_infra
gvashchenkolineate Infra repository


# ДЗ-3 "Знакомство с облачной инфраструктурой"

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


# ДЗ-4 "Деплой тестового приложения"

testapp_IP = 35.205.238.0
testapp_port = 9292


Создание EC2-инстанса для приложения __reddit-app__ с помощью cli-утилиты gcloud,
установка и запуск приложения:
```
gcloud compute instances create reddit-app-5 \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup_script.sh
```
