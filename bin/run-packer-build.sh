#!/usr/bin/env bash

ANSIBLE_FOLDER=ansible
PACKER_FOLDER=packer

function run-packer-build {
    packer build -var-file=$PACKER_FOLDER/vars/template.private.pkrvars.json \
        -var-file=$PACKER_FOLDER/vars/$2 \
        -var 'ansible_folder='$ANSIBLE_FOLDER \
        $PACKER_FOLDER/$1
}

function run-proxmox-packer-build {
    run-packer-build proxmox-template.json $1
}

function run-raspi-packer-build {
    run-packer-build raspios-template.json $1
}