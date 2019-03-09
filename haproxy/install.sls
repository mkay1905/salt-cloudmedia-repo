haproxy:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: haproxy

config_haproxy:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/files/haproxy.cfg
    - user: haproxy
    - group: haproxy
    - mode: 644
    - watch_in:
      - service: haproxy

push_null_backend:
  file.managed:
    - name: /etc/haproxy/errors/null.http
    - source: salt://haproxy/files/null.http
    - user: haproxy
    - group: haproxy
    - makedirs: True
