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


 - Создание EC2-инстанса для приложения __reddit-app__ с помощью cli-утилиты gcloud,
   установка и запуск приложения:

    ```
    gcloud compute instances create reddit-app \
      --boot-disk-size=10GB \
      --image-family ubuntu-1604-lts \
      --image-project=ubuntu-os-cloud \
      --machine-type=g1-small \
      --tags puma-server \
      --restart-on-failure \
      --metadata-from-file startup-script=startup_script.sh
    ```

    Или можно подгружать startup-script из URL

    Например, из файла в репозитории:
    ```
    gcloud compute instances create reddit-app \
      --boot-disk-size=10GB \
      --image-family ubuntu-1604-lts \
      --image-project=ubuntu-os-cloud \
      --machine-type=g1-small \
      --tags puma-server \
      --restart-on-failure \
      --metadata startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2020-02/gvashchenkolineate_infra/cloud-testapp/startup_script.sh
    ```

    или gist'а:
    ```
    gcloud compute instances create reddit-app-7 \
      --boot-disk-size=10GB \
      --image-family ubuntu-1604-lts \
      --image-project=ubuntu-os-cloud \
      --machine-type=g1-small \
      --tags puma-server \
      --restart-on-failure \
      --metadata startup-script-url=https://gist.githubusercontent.com/gvashchenkolineate/8b49d3dce947eb5167985487443d09d5/raw/3c856d666df59a4ffef7adc3f441cface4949c1b/reddit-app-startup-script
    ```

 - Открытие порта в файрволе для приложение
   (Создание файрвол правила):
   ```
   gcloud compute firewall-rules create default-puma-server \
      --target-tags=puma-server \
      --source-ranges=0.0.0.0/0 \
      --allow=tcp:9292
   ```
