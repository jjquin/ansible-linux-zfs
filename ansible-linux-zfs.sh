#!/bin/bash

set -euo pipefail

cwd="$(pwd)"

if [[ "$cwd" == /tmp/* ]]; then
  echo "Firstboot detected (running from /tmp): using firstboot.cfg and local collections"
  ANSIBLE_CONFIG="$cwd/firstboot.cfg"
else
  echo "Normal run: using ansible.cfg and ~/.local/share/ansible/collections"
  ANSIBLE_CONFIG="$cwd/ansible.cfg"
fi

requirements_file="$cwd/collections/requirements.yml"
playbook_file="$cwd/playbooks/site.yml"

if [[ ! -f "$requirements_file" ]]; then
  echo "ERROR: Requirements file not found at $requirements_file"
  exit 1
fi

if [[ ! -f "$playbook_file" ]]; then
  echo "ERROR: Playbook file not found at $playbook_file"
  exit 1
fi

# All Ansible commands below will use the chosen config
ansible-galaxy collection install -r "$requirements_file"
ansible-playbook "$playbook_file" --ask-become-pass "$@"
