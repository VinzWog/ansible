# Basics
Test ansible SSH connection
```
ansible [host] -m ping --user=[remote_user]
```
List all variables and their values
```
ansible [host] -m setup
```
# Playbooks
Use playbooks with ssh and vault pass
```
ansible-playbook playbook_name.yml --extra-vars "target=[host]" --ask-pass --ask-vault-pass
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
# Roles
Execute all roles of production.yml whith inventory production_hosts.inv, user root and asking for ssh and vault pass
```
ansible-playbook production.yml -i production_hosts.inv -u root --ask-pass --ask-become-pass --ask-vault-pass
```
Execute all roles of dev.master.yml whith inventory file host.ini, user root and vault pass in file vault.txt
```
ansible-playbook dev.master.yml -i ~/Documents/host.ini -u root --ask-sudo-pass --vault-password-file ~/Documents/vault.txt
```