clone_package_letsencrypt:
  cmd.run:
    - name: git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
    - unless: test -f /opt/letsencrypt

haproxy_create_acl:
  file.line:
    - name: /etc/haproxy/haproxy.cfg
    - mode: ensure
    - content: |
        acl letsencrypt_check path_beg /.well-known/acme-challenge
            use_backend letsencrypt_backend if letsencrypt_check
    - indent: 4
    - after: default_backend         null

haproxy_create_backend:
  file.line:
    - name: /etc/haproxy/haproxy.cfg
    - mode: insert
    - location: end
    - content: |
        backend letsencrypt_backend
            http-request set-header Host letsencrypt.requests
            dispatch 10.0.0.51:8000

reload_haproxy:
  cmd.run:
    - name: systemctl reload haproxy
    - unless: haproxy -f /etc/haproxy/haproxy.cfg -c
