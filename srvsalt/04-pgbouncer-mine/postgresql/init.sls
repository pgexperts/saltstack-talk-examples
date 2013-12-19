{% set pgshortversion = pillar['packages']['postgresql_version'].translate(None, '.') %}
{% set pgversion = pillar['packages']['postgresql_version'] %}

postgresql-packages:
  pkg.installed:
    - pkgs:
      - postgresql{{ pgshortversion }}-contrib
      - postgresql{{ pgshortversion }}-devel
      - postgresql{{ pgshortversion }}-server
    - require:
      - pkg: postgresql.org-repo

pg-initdb:
  cmd.wait:
  - name: /usr/pgsql-{{ pgversion }}/bin/initdb -D /var/lib/pgsql/{{ pgversion }}/data -E UTF8 --locale C && rm -f /var/lib/pgsql/{{ pgversion }}/data/pg_hba.conf /var/lib/pgsql/{{ pgversion }}/data/postgresql.conf
  - user: postgres
  - watch: 
    - pkg: postgresql-packages
  - unless: ls /var/lib/pgsql/{{ pgversion }}/data/base

/var/lib/pgsql/{{ pgversion }}/data/postgresql.conf:
    file.managed:
      - source: salt://postgresql/postgresql.conf.jinja
      - template: jinja
      - user: postgres
      - group: postgres
      - replace: False
      - context:
         max_connections: 100
      - require:
        - cmd: pg-initdb

/var/lib/pgsql/{{ pgversion }}/data/pg_hba.conf:
    file.managed:
      - source: salt://postgresql/pg_hba.conf
      - user: postgres
      - group: postgres
      - replace: False
      - require:
        - cmd: pg-initdb

postgresql-{{ pgversion }}:
  service:
    - running
    - enable: True
    - require:
      - file: /var/lib/pgsql/{{ pgversion }}/data/postgresql.conf
      - file: /var/lib/pgsql/{{ pgversion }}/data/pg_hba.conf

roles:
  grains.present:
    - value: postgresql_server

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
