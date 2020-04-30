# gvashchenkolineate_infra [![Build Status](https://travis-ci.com/Otus-DevOps-2020-02/gvashchenkolineate_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2020-02/gvashchenkolineate_infra)
gvashchenkolineate Infra repository

---

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

---

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

---

# ДЗ-5 "Сборка образов VM при помощи Packer"

 - Создан Packer-шаблон для сборки [базового образа ВМ](./packer/ubuntu16.json) с предустановленными Ruby, MongoDB
 - Packer-шаблон параметризован пользовательскими переменными ([пример](./packer/variables.json.example))
 - Создан Packer-шаблон для сборки [полного образа ВМ](./packer/immutable.json) на основе базового образа с предустановленным и автоматически запускаемым
   с помощью **systemd unit** приложением
 - Gcloud-команда создания инстанса вынесена в скрипт [create-redditvm.sh](./config-scripts/create-redditvm.sh)

# ДЗ-6 "Практика IaC с использованием Terraform"

 - Создан [Terraform-модуль](./terraform/main.tf) для
    - создания инстанса на основе [базового образа ВМ](./packer/ubuntu16.json).
    - деплоя приложения Monolith Reddit app на этот инстанс
    - создания правила файрвола
    - добавления списка ssh-ключей для доступа к инстансу
 - Модуль параметризирован ([пример](./terraform/terraform.tfvars.example) файла с переменными)
 - Количество поднимаемых и добавляемых в load balancing инстансов приложения Monolith Reddit app
   конфигурируется через переменную `instance_count`

 - Проблема при объявлении ssh-ключей доступа в Terraform-модуле:
   При выполнении `terraform apply` все ssh-ключи, отличные от объявленных в Terraform-модуле,
   в том числе и добавленные через веб-интерфейс GCP, будут удалены.

 - Проблема при добавлении ещё одного инстанса копированием кода ресурса:
   Копирование кода. Также приходится вручную добавлять вывод IP адреса нового инстанса по имени ресурса.
   Т.е. нельзя сделать вывод или включение в instance_group через, указав список через `*`

---

# ДЗ-7 "Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform"

 - Создание лоад балансера отменено.
 - Создано правило файрвола для ssh-подключения и вынесено в отдельный Terraform-модуль [vpc](./terraform/modules/vpc)
 - Созданы отдельные Packer-шаблоны для создания образов [VM приложения](./packer/app.json) и [VM БД](./packer/db.json).
   _⭐⭐ Деплой приложения при поднятии VM можно включать/выключать с помощью переменной `deploy_app`._
 - Созданы Terraform-модули для поднятия инстансов [приложения](./terraform/modules/app) и [БД](./terraform/modules/db)
 - Созданы два отдельных Terraform-подпроекта для разных окружений [prod](./terraform/prod) и [stage](./terraform/stage)
 - В качестве бэкенда для Terraform используется GCS корзина.
   _⭐ Управление инфраструктурой теперь можно вести не только из одного места._
   _При одновременном запуске из разных мест выполнение будет блокироваться механизмом [state lock](https://www.terraform.io/docs/state/locking.html)._

---

# ДЗ-8 "Управление конфигурацией. Основные DevOps инструменты. Знакомство с Ansible"

  - Создан Ansible-проект с инвентори из хостов, поднимаемых с помощью Terraform-проекта [stage](./terraform/stage),
    в различных форматах: ini, yaml, json

  - Добавлен простейший плэйбук [clone.yml](./ansibe/clone.yml).

    Выполненеие Ansible-плэйбука при наличии уже склонированного репозитория
    даёт результат:
    ```
    PLAY RECAP **********************************************************************************************
    appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    А при отсутствии или после его удаления (`ansible app -m command -a 'rm -rf ~/reddit'`) даёт результат:
    ```
    PLAY RECAP **********************************************************************************************
    appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    Т.е. появилось `changed=1`, а значит в первом случае Ansible не производит никаких действий, а во втором - клонирует репозиторий.

  - Для генерации inventory в json-формате можно воспользоваться командой

    ` ansible-inventory --list > inventory.json`

    Чтобы использовать inventory в json-формате потребуется скрипт (напр. [inventory.py](ansible/old/inventory.py)),
    выводящий этот json. Использовать эту связку (скрипт + json) можно командой:

    `ansible all -i inventory.py -m ping`

    или

    `ansible all -m ping` (если прописать `inventory = ./inventory.py`  в [ansible.cfd](./ansible/ansible.cfg))

  - Вне рамок ДЗ добавлен инвентори, использующий [gcp_compute](https://docs.ansible.com/ansible/latest/plugins/inventory/gcp_compute.html) inventory plugin.
    Использование командой:
    `ansible all -i inventory.gcp.yml -m ping`
    Для его функционирования требуется в GCP **IAM & Admin** создать Service Account
    с ролью `Compute Engine - Compute Instance Admin (v1)` и скачать service account file (файл ключа).

---

# ДЗ-9 "Деплой и управление конфигурацией с Ansible"

##### Ansible

  - Создан плэйбук [reddit_app_one_play.yml](ansible/playbooks/reddit_app_one_play.yml)
    из одного сценария для донастройки app & db инстансов и деплоя

  - Создан плэйбук [reddit_app_multiple_plays.yml](ansible/playbooks/reddit_app_multiple_plays.yml),
    разбитый на три сценария: донастройки app, db и деплоя

  - Предыдущий плэйбук разбит на три отдельных плэйбука
     - [db.yml](ansible/playbooks/db.yml)
     - [app.yml](ansible/playbooks/app.yml)
     - [deploy.yml](ansible/playbooks/deploy.yml)

    Их последовательный вызов осуществяется четвертым плэйбуком:
     - [site.yml](ansible/playbooks/site.yml)

  - (⭐) Вместо статического, использовано динамическое инвентори (**gcp_compute** plugin)
    с автоматическим разбиением на именованные группы.
    Определение переменной `db_host` изменено с хардкода на получение из динамического инвентори.

##### Packer

  - Провижининг reddit-app-base и reddit-db-base заменен с bash-скриптов на Ansible плэйбуки:
     - [packer_app.yml](ansible/playbooks/packer_app.yml)
     - [packer_db.yml](ansible/playbooks/packer_db.yml)

##### Комментарии

  Плэйбуки используют переменные, хэндлеры, j2-шаблоны, модули, динамическое инвентори.
  Для использования "цельных" плэйбуков необходимо указывать нужный тэг.
  Плэйбуки обкатывались на окружении, поднимаемом проектом [terraform/stage](./terraform/stage).


---

# ДЗ-10 "Ansible: работа с ролями и окружениями"

  - Созданы Ansible-роли и задействованы в соответствующих плэйбуках для донастройки инстансов:
    - [app](./ansible/roles/app)
    - [db](./ansible/roles/db)

    Запуск обоих происходит при выполнении плэйбука [site.yml](./ansible/playbooks/site.yml)
    ```
    ansible-playbook site.yml -i environment/[stage|prod]/inventory.gcp.yml
    ```

    В этом и последующих пунктах плэйбуки обкатывались на окружениях, поднимаемых Terraform-проектами
      - [terraform/stage](./terraform/stage)
      - [terraform/prod](./terraform/prod)

  - Выделены два окружения со своими переменными и инвентори:
    - [stage](./ansible/environments/stage)
    - [prod](./ansible/environments/prod)

  - Использована Community-роль [jdauphant.nginx](https://github.com/jdauphant/ansible-role-nginx)
    для настройки обратного прокси.
    Теперь приложение после выполнения плэйбука [site.yml](./ansible/playbooks/site.yml)
    доступно на стандартном http порту.
    _(Доступ к порту puma(9292) при этом запрещен)_

  - Добавлен плэйбук [users.yml](./ansible/playbooks/users.yml) для создания пользователей на всех инстансах,
    пароли для которых зашифрованы с помощью Ansible Vault отдельно для каждого окружения.
    _(Vault key хранится локально в `~/.ansible/vault.key`)_

    Проверка после выполнения плэйбука [site.yml](./ansible/playbooks/site.yml)
    осуществлена подключением на инстанс и переключением на каждого созданного пользователя с помощью пароля.

  - (⭐) Динамическое инвентори (**gcp_compute**) из предыдущего ДЗ
    с автоматическим разбиением на именованные группы переиспользовано для stage и prod окружений.

  - (⭐⭐) В TravisCI билд добавлены `before_install` джобы для
    - `packer validate` для всех шаблонов
    - `terraform validate` и `tflint` для окружений stage и prod
    - `ansible-lint` для Ansible плейбуков

    В README заголовок также добавлена иконка статуса TravisCI билда коммитов и PR в `master`
