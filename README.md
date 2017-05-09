Test ansible SSH connection
```
ansible host -m ping --user=[remote_user]
```
List all variables and their values
```
ansible [host] -m setup
```
# Playbooks
Use playbooks with vault
```
ansible-playbook playbook_name.yml --ask-vault-pass
```
Use playbooks with ssh user password
```
ansible-playbook playbook_name.yml --extra-vars "target=[host]" --ask-pass
```
Use playbooks with ssh user password then sudo password
```
ansible-playbook playbook_name.yml --extra-vars "target=[host]" --ask-pass --ask-become-pass
```
Safely limiting Ansible playbooks to a single machine
```
ansible-playbook playbook_name.yml --extra-vars "target=[host]"
```
To use with playbooks beginning by
```
- hosts: '{{ target }}'
```
