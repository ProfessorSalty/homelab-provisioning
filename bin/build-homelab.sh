#!/usr/bin/env sh

TASKS=$(python -c 'import os, json; print json.dumps(os.listdir("ansible/tasks"))')

ansible-playbook -i 192.168.1.171, \
    ansible/build-homelab.yml \
    --extra-vars="{\"homelabfiles\": $TASKS, \"ansible_ssh_pass\": \"mantle inward maestro\", \"ansible_ssh_user\": \"toor\"}"
