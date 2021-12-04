#!/usr/bin/env bash

CONFIGS_FOLDER=../images/templates
VARS_FOLDER=../images/vars


function check-for-jinja {
  if [[ -z $(which jinja2) ]]; then
    echo Please install jinja2 and the cli tool
    echo pip install jinja2 jinja2-cli
    exit 1
  fi
}

function run-jinja {
  check-for-jinja
  jinja2 "$1" "$2" --strict
}

function run-packer-build {
    packer build -var-file=$VARS_FOLDER/template.private.pkrvars.json \
        -var-file=$VARS_FOLDER/$2 \
        $CONFIGS_FOLDER/$1
}

function run-proxmox-packer-build {
    run-packer-build proxmox-template.json $1
}

function run-raspi-packer-build {
    run-packer-build raspios-template.json $1
}

