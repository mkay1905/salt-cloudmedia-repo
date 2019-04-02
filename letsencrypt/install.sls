git:
  pkg:
    - installed

nginx:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx

letsencrypt_config:
  file.managed:
    - name: /etc/nginx/conf.d/letsencrypt.conf
    - source: salt://letsencrypt/files/letsencrypt.conf
    - mode: 644

config_letsencrypt:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://letsencrypt/files/nginx.conf
    - mode: 644
    - watch_in:
      - service: nginx
