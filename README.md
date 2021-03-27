### Useful commands

* _Generate encrypted user password_

  > python3 -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'

* _Genenrate QR code of random password after cloud-init_

  > awk -F: '/\w+:\w+$/ { print $2 }' /var/log/cloud-init-output.log | qrencode -t UTF8


### Useful links
http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/891/doc/examples/cloud-config.txt