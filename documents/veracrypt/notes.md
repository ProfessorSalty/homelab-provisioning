### Use the following command to create a VeraCrypt vault

#### First, the outer partition

```
veracrypt --text --create --volume-type=normal /dev/sda1 --encryption=aes --hash=sha-512 --filesystem=ext4 --password=STRONGP@33WORD --pim=0 -k "" --random-source=/dev/urandom
```

#### Then, the inner

```
veracrypt --text -c --volume-type=hidden /dev/sda1 --size=500M --encryption=aes --hash=sha-512 --filesystem=ext4 -p STRONGP@33WORDHID --pim=0 -k "" --random-source=/dev/urandom
```