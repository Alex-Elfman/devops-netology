# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.

```yaml
...
- name: Install lighthouse
  hosts: lighthouse
  handlers:
    - name: Nginx reload
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted

  pre_tasks:
    - name: Install git
      become: true
      ansible.builtin.yum:
        name: git
        state: present

    - name: Install epel-release
      become: true
      ansible.builtin.yum:
        name: epel-release
        state: present

    - name: Install nginx
      become: true
      ansible.builtin.yum:
        name: nginx
        state: present

    - name: Apply nginx config
      become: true
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        mode: 0644

  tasks:
    - name: Clone repository
      become: true
      ansible.builtin.git:
        repo: "{{ lighthouse_repo }}"
        dest: "{{ lighthouse_dir }}"
        version: master

    - name: Apply config
      become: true
      ansible.builtin.template:
        src: lighthouse.conf.j2
        dest: /etc/nginx/conf.d/lighthouse.conf
        mode: 0644
      notify: Nginx reload
  tags: lighthouse
...
```

2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.

```yaml
---
clickhouse:
  hosts:
    study-0:
      ansible_user: centos
      ansible_ssh_private_key_file: ~/.ssh/yc
      ansible_host: 158.160.40.166

vector:
  hosts:
    study-1:
      ansible_user: centos
      ansible_ssh_private_key_file: ~/.ssh/yc
      ansible_host: 158.160.37.121

lighthouse:
  hosts:
    study-2:
      ansible_user: centos
      ansible_ssh_private_key_file: ~/.ssh/yc
      ansible_host: 158.160.41.59
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ ansible-lint ~/work/devops-netology/Homework/8/3/playbook/site.yml 
WARNING  Listing 6 violation(s) that are fatal
key-order[task]: You can improve the task key order to: name, tags, block, rescue
~/work/devops-netology/Homework/8/3/playbook/site.yml:13 Task/Handler: Set clickhouse

yaml[empty-lines]: Too many blank lines (3 > 2)
~/work/devops-netology/Homework/8/3/playbook/site.yml:51

yaml[octal-values]: Forbidden implicit octal value "0644"
~/work/devops-netology/Homework/8/3/playbook/site.yml:88

yaml[octal-values]: Forbidden implicit octal value "0644"
~/work/devops-netology/Homework/8/3/playbook/site.yml:125

yaml[octal-values]: Forbidden implicit octal value "0644"
~/work/devops-netology/Homework/8/3/playbook/site.yml:140

yaml[new-line-at-end-of-file]: No new line character at the end of file
~/work/devops-netology/Homework/8/3/playbook/site.yml:142

Read documentation for instructions on how to ignore specific rule violations.

                      Rule Violation Summary                      
 count tag                           profile rule associated tags 
     1 key-order[task]               basic   formatting           
     1 yaml[empty-lines]             basic   formatting, yaml     
     1 yaml[new-line-at-end-of-file] basic   formatting, yaml     
     3 yaml[octal-values]            basic   formatting, yaml     

Failed: 6 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'min'.
vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ ansible-lint ~/work/devops-netology/Homework/8/3/playbook/site.yml 
WARNING  Listing 1 violation(s) that are fatal
key-order[task]: You can improve the task key order to: name, tags, block, rescue
~/work/devops-netology/Homework/8/3/playbook/site.yml:13 Task/Handler: Set clickhouse

Read documentation for instructions on how to ignore specific rule violations.

               Rule Violation Summary               
 count tag             profile rule associated tags 
     1 key-order[task] basic   formatting           

Failed: 1 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'min'.
vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ ansible-lint ~/work/devops-netology/Homework/8/3/playbook/site.yml 

Passed: 0 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'production'.
vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ 
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ ansible-playbook -i ~/work/devops-netology/Homework/8/3/playbook/inventory/prod.yml ~/work/devops-netology/Homework/8/3/playbook/site.yml --check

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [study-0]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************************************
ok: [study-0] => (item=clickhouse-client)
ok: [study-0] => (item=clickhouse-server)
failed: [study-0] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0755", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************************************
ok: [study-0]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************************************
ok: [study-0]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************************************

TASK [Create database] *****************************************************************************************************************************************************************************************************************
skipping: [study-0]

PLAY [Install Vector] ******************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Create directory for vector "/opt/vector"] ***************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Get vector distrib] **************************************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Extract vector in the installation directory] ************************************************************************************************************************************************************************************
skipping: [study-1]

TASK [Remove vector packages distribs] *************************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Copy server configuration file] **************************************************************************************************************************************************************************************************
ok: [study-1]

PLAY [Install lighthouse] **************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Install git] *********************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Install epel-release] ************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Install nginx] *******************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Apply nginx config] **************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Clone repository] ****************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Apply config] ********************************************************************************************************************************************************************************************************************
ok: [study-2]

PLAY RECAP *****************************************************************************************************************************************************************************************************************************
study-0                    : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
study-1                    : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
study-2                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ 
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ ansible-playbook -i ~/work/devops-netology/Homework/8/3/playbook/inventory/prod.yml ~/work/devops-netology/Homework/8/3/playbook/site.yml --diff

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [study-0]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************************************
ok: [study-0] => (item=clickhouse-client)
ok: [study-0] => (item=clickhouse-server)
failed: [study-0] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0755", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************************************
ok: [study-0]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************************************
ok: [study-0]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************************************

TASK [Create database] *****************************************************************************************************************************************************************************************************************
ok: [study-0]

PLAY [Install Vector] ******************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Create directory for vector "/opt/vector"] ***************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Get vector distrib] **************************************************************************************************************************************************************************************************************
changed: [study-1]

TASK [Extract vector in the installation directory] ************************************************************************************************************************************************************************************
ok: [study-1]

TASK [Remove vector packages distribs] *************************************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/tmp/vector-0.22.0-x86_64-unknown-linux-musl.tar.gz",
-    "state": "file"
+    "state": "absent"
 }

changed: [study-1]

TASK [Copy server configuration file] **************************************************************************************************************************************************************************************************
ok: [study-1]

PLAY [Install lighthouse] **************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Install git] *********************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Install epel-release] ************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Install nginx] *******************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Apply nginx config] **************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Clone repository] ****************************************************************************************************************************************************************************************************************
ok: [study-2]

TASK [Apply config] ********************************************************************************************************************************************************************************************************************
ok: [study-2]

PLAY RECAP *****************************************************************************************************************************************************************************************************************************
study-0                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
study-1                    : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
study-2                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

vm@osipov:~/work/devops-netology/Homework/8/3/terraform$ 
```

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

### Playbook содержит три play

- Install Clickhouse - содержит handler и tasks, необходимые для установки Clickhouse
- Install Vector - содержит tasks, необходимые для установки Vector
- Install lighthouse - содержит tasks, необходимые для установки Lighthouse

Краткая структура файла с пояснениями:
- name: Install Clickhouse -- начало play с установкой Clickhouse

  handlers: -- В этом разделе записываются задачи, выполнять которые требуется, если какая либо задача произвела изменение и сообщила об этом
    - name: Start clickhouse service -- Здесь выполняется перезагрузка установленного Clickhouse
      tasks: -- В этом разделе записываются основные задачи для play "Install Clickhouse"
    - block: -- Этот модуль объединяет две задачи, если первая завершится с ошибкой, запустится вторая - rescue
        - name: Get clickhouse distrib  -- Получение дистрибутива

        - rescue
        - name: Get clickhouse distrib -- Получение дистрибутива, если в предыдущей задаче возникла ошибка

    - name: Install clickhouse packages -- Установка Clickhouse с помощью модуля yum

      notify: Start clickhouse service -- Сообщение модуля, с именем handler'а, который надо запустить, если были произведены изменения

    - name: Remove clickhouse packages distribs -- Удаление файлов с дистрибутивом

- name: Install Vector -- начало play с установкой Vector
    - name: Create directrory for vector "{{ vector_dir }}" -- Создание каталога для установки в него Vector

    - name: Get vector distrib
    - name: Extract vector in the installation directory -- Разархивирование дистрибутива Vector в каталог установки

    - name: Remove vector packages distribs -- Удаление архива с дистрибутивом
    - name: Copy server configuration file -- копирование конфигурации из шаблона `vector.toml` на сервер `{{ vector_dir }}/vector.toml` 

- name: Install lighthouse -- начало play с установкой Lighthouse 
   handlers: -- в этом разделе записываются задачи, выполнять которые требуется, если какая либо задача произвела изменение и сообщила об этом
    - name: Nginx reload -- Перезапуск сервиса `Nginx`
   pre_tasks: -- в этом разделе описываются задачи, которые должны выполниться до основных `tasks`
    - name: Install git -- установка `Git` с помощью `yum`
    - name: Install epel-release -- установка `epel-release` с помощью `yum`
    - name: Install nginx -- установка `nginx` с помощью `yum`
    - name: Apply nginx config -- копирование конфигурации из шаблона `nginx.conf.j2` на сервер `/etc/nginx/nginx.conf`
      tasks:
    - name: Clone repository -- клонирование репозитория "{{ lighthouse_repo }}" в "{{ lighthouse_dir }}"
    - name: Apply config -- копирование конфигурации из шаблона `lighthouse.conf.j2` на сервер `/etc/nginx/conf.d/lighthouse.conf`

### Файлы с переменными для playbook:

clickhouse/vars.yaml

clickhouse_version: "22.3.3.44" -- Версия Clickhouse для установки  
clickhouse_packages: -- Список пакетов для скачивания и установки
- clickhouse-client
- clickhouse-server
- clickhouse-common-static

vector/vars.yaml

vector_version: "0.22.0" -- Версия Vector для установки  
vector_dir: "/opt/vector" -- Директория установки Vector

lighthouse/vars.yaml

lighthouse_repo: "https://github.com/VKCOM/lighthouse.git" -- репозиторий с Lightouse
lighthouse_dir: "/opt/lighthouse" -- директория для установки Lighthouse
 
Для работы playbook требуется выполнить команду:
```bash
ansible-playbook -i inventory/prod.yml site.yml
```
если добавить к команде --tags clickhouse - будут выполнены все задачи, относящиеся к Clickhouse
если добавить к команде --tags vector - будут выполнены все задачи, относящиеся к Vector
если добавить к команде --tags lighthouse - будут выполнены все задачи, относящиеся к Lighthouse

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---