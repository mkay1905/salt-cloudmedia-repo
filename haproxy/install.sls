push_null_backend:
  file.managed:
    - name: /etc/haproxy/errors/null.http
    - source: salt://haproxy/files/null.http
    - makedirs: True

haproxy:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
      - pkg: haproxy
    - watch:
      - file: /etc/haproxy/haproxy.cfg
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/files/haproxy.cfg
    - user: haproxy
    - group: haproxy
    - mode: 644
    - require:
      - pkg: haproxy
