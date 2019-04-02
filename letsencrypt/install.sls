package_letsencrypt_need:
  pkg.installed:
    - pkgs:
      - git
      - bc
      - nginx
    - service.running:
      - enable: True

nginx:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
      - pkg: nginx

www_html_dir:
  file.directory:
    - name: /var/www/html 
    - user: nginx
    - group: nginx
    - mode: 755
    - makedirs: True

letsencrypt_config:
  file.managed:
    - name: /etc/nginx/conf.d/letsencrypt.conf
    - source: salt://letsencrypt/files/letsencrypt.conf
    - mode: 644
    - watch:
      - service: nginx

config_letsencrypt:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://letsencrypt/files/nginx.conf
    - mode: 644
    - watch:
      - service: nginx
