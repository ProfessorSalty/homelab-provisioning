#!/usr/bin/env bash

if [[ -z $(which openssl) ]]; then
  echo "OpenSSL must be installed"
  exit 1
fi

if [[ -f ~/.homelab_vault_password ]]; then
  echo "Vault file already exists at ~/.homelab_vault_password"
fi

NEW_PASSWORD=$(openssl rand -base64 32)

cat > ~/.homelab_vault_password << HEREDOC
  $NEW_PASSWORD
HEREDOC

chmod 0600 ~/.homelab_vault_password