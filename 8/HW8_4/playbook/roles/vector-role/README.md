Vector-role
=========

This role install Vector on CentOS 7

Role Variables
--------------

|vars|description|
|----|-----------|
|vector_dir|Directory for installation|
|vector_config|YAML config for Vector copying in vector.yaml|
Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: vector-role}

License
-------

MIT

Author Information
------------------

Aleksandr Makarov
