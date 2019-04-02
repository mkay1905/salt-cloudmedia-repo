letsencrypt_auto_renew_config:
  file.managed:
    - name: /usr/local/etc/le-renew-haproxy.ini
    - source: salt://letsencrypt/files/le-renew-haproxy.ini
    - mode: 644

letsencrypt_auto_renew_sh:
  file.managed:
    - name: /usr/local/etc/le-renew-haproxy.sh
    - source: salt://letsencrypt/files/le-renew-haproxy.sh
    - mode: 755
