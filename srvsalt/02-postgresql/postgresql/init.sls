postgresql.org-repo:
  pkg.installed:
    - sources:
      - pgdg-centos92: http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm
    - require_in:
      - pkg: postgresql-packages

postgresql-packages:
  pkg.installed:
    - pkgs:
      - postgresql92
      - postgresql92-contrib
      - postgresql92-devel
      - postgresql92-server
    - require:
      - pkg: postgresql.org-repo

pg-initdb:
  cmd.wait:
  - name: /usr/pgsql-9.2/bin/initdb -D /var/lib/pgsql/9.2/data -E UTF8 --locale C && rm -f /var/lib/pgsql/9.2/data/pg_hba.conf /var/lib/pgsql/9.2/data/postgresql.conf
  - user: postgres
  - watch: 
    - pkg: postgresql-packages
  - unless: ls /var/lib/pgsql/9.2/data/base

/var/lib/pgsql/9.2/data/postgresql.conf:
    file.managed:
      - source: salt://postgresql/postgresql.conf.jinja
      - template: jinja
      - user: postgres
      - group: postgres
      - replace: False
      - context:
         conn: 100
      - require:
        - cmd: pg-initdb

/var/lib/pgsql/9.2/data/pg_hba.conf:
    file.managed:
      - source: salt://postgresql/pg_hba.conf
      - user: postgres
      - group: postgres
      - replace: False
      - require:
        - cmd: pg-initdb

postgresql-9.2:
  service:
    - running
    - require:
      - file: /var/lib/pgsql/9.2/data/postgresql.conf
      - file: /var/lib/pgsql/9.2/data/pg_hba.conf

# This state doesn't work on RHEL6 derivatives
# see issue: https://github.com/saltstack/salt/issues/8719
#postgresql:
#  iptables.append:
#    - table: filter
#    - chain: INPUT
#    - jump: ACCEPT
#    - match: state
#    - connstate: NEW
#    - dport: 5432
#    - proto: tcp
#    - sport: 1025:65535
#    - save: True
