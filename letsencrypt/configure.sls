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
            redirect scheme https code 301 if !{ ssl_fc } !letsencrypt_check
            use_backend letsencrypt_backend if letsencrypt_check
    - indent: 4
    - after: '#frontend_http'

haproxy_create_backend_letsencrypt:
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
