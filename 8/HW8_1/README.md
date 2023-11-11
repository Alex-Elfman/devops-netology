# Домашнее задание к занятию 1 «Введение в Ansible»

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

> `some_fact` имеет значение `12`

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] ******************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *****************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] ******************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

> Поднял из 1го образа 2 контейнера с именами centos7, ubuntu

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Print os facts] ***************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
[WARNING]: Distribution debian 10 on host ubuntu should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [ubuntu]
[WARNING]: Distribution debian 10 on host centos7 should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [centos7]

TASK [Print OS] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Debian"
}
ok: [ubuntu] => {
    "msg": "Debian"
}

TASK [Print fact] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP **************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```bash
TASK [Print fact] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

```bash
TASK [Print fact] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb eb default fact"
}
```

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```bash

vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Print os facts] ***************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
[WARNING]: Distribution debian 10 on host centos7 should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [centos7]
[WARNING]: Distribution debian 10 on host ubuntu should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [ubuntu]

TASK [Print OS] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Debian"
}
ok: [ubuntu] => {
    "msg": "Debian"
}

TASK [Print fact] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb eb default fact"
}

PLAY RECAP **************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-vault encrypt  group_vars/deb/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-vault encrypt  group_vars/el/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
[WARNING]: Distribution debian 10 on host centos7 should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [centos7]
[WARNING]: Distribution debian 10 on host ubuntu should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [ubuntu]

TASK [Print OS] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Debian"
}
ok: [ubuntu] => {
    "msg": "Debian"
}

TASK [Print fact] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb eb default fact"
}

PLAY RECAP **************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-doc netology.sample plugin -t connection -l
ansible.builtin.local          execute on controller  
```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```bash
vm@osipov:~/work/devops-netology/Homework/8/1/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [localhost]
[WARNING]: Distribution debian 10 on host ubuntu should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [ubuntu]
[WARNING]: Distribution debian 10 on host centos7 should use /usr/bin/python3, but is using /usr/local/bin/python3.8, since the discovered platform python
interpreter was not present. See https://docs.ansible.com/ansible-core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [centos7]

TASK [Print OS] *********************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Debian"
}
ok: [ubuntu] => {
    "msg": "Debian"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *******************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb eb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP **************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
