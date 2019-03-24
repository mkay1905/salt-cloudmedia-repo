clone_package_letsencrypt:
  cmd.run:
    - name: git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
    - unless: test -f /opt/letsencrypt
