# Basics
Test ansible SSH connection
```
ansible [host] -m ping --user=[remote_user]
```
List all variables and their values
```
ansible [host] -m setup
```
# Run in container with ansible-docker

* Add command alias in .zsh file
```
vim ~/Dropbox/Mackup/.oh-my-zsh/custom/vinz.zsh
```
```
docker run --rm \
  -e MY_UID=501 \
  -e MY_GID=20 \
  -v ${HOME}/.ssh/id_rsa:/home/ansible/.ssh/id_rsa:ro \
  -v ~/Documents/Ansible:/ansible \
  -v ~/Documents/GitHub/ansible:/github \
  -e "ANSIBLE_FORCE_COLOR=true" \
  -e "ANSIBLE_ROLES_PATH=/github/roles/internals:/github/roles/externals" \
  -e "ANSIBLE_COLLECTIONS_PATHS=/github/" \
  -e "ANSIBLE_HOST_KEY_CHECKING=false" \
  -e "ANSIBLE_RETRY_FILES_ENABLED=false" \
  -e "ANSIBLE_FORCE_COLOR=true" \
  ### Mitogen acivation - Does not support collections yet
  -e "ANSIBLE_STRATEGY=mitogen_linear" \
  -e "ANSIBLE_STRATEGY_PLUGINS=/usr/lib/python3.8/site-packages/ansible_mitogen/plugins/strategy" \
  m4vr0x/wognet-ansible
  ```
