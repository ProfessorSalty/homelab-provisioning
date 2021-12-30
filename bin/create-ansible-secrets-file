#!/usr/bin/env bash

if [[ -z $(which ansible-vault) ]]; then
  echo "Ansible must be install (missing ansible-vault)"
  exit 1
fi

if [[ ! -f ~/.homelab-vault-password ]]; then
  echo "Please generate a password file before proceeding"
  exit 1
fi

cat > ~/.homelab-ansible-secrets.yml << HEREDOC
  mediauser: << ADD PASSWORD >>
  moviesuser: << ADD PASSWORD >>
  showsuser: << ADD PASSWORD >>
  musicuser: << ADD PASSWORD >>
HEREDOC

ansible-vault encrypt --vault-password-file ~/.homelab_vault_password ~/.homelab-ansible-secrets.yml
