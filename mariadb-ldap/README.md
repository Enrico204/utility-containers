You need to mount a r/o file in `/etc/pam_ldap.conf` with this content:

```
base dc=example,dc=com
uri ldap://dc1.example.com/
ldap_version 3
timelimit 5
bind_timelimit 5
pam_password clear
ssl start_tls
tls_checkpeer yes
```

You need to replace `dc=example,dc=com` and `dc1.example.com` with your configuration.
