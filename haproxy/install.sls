haproxy:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: haproxy
    - watch:
      - file: /etc/haproxy/haproxy.cfg

push_null_backend:
  file.managed:
    - name: /etc/haproxy/errors/null.http
    - source: salt://haproxy/files/null.http
    - user: haproxy
    - group: haproxy
    - makedirs: True

haproxy_certs_directory:
  file.directory:
    - name: /etc/haproxy/certs
    - user: haproxy
    - group: haproxy
    - mode: 755
    - makedirs: True

config_haproxy:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/files/haproxy.cfg
    - user: haproxy
    - group: haproxy
    - mode: 644
    - require:
      - service: haproxy
