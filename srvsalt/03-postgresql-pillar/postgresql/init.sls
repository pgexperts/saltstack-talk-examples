{% set pgshortversion = pillar['packages']['postgresql_version'].translate(None, '.') %}
{% set pgversion = pillar['packages']['postgresql_version'] %}

# Would like to come up with a better way of determining the repo RPM
# but haven't yet
postgresql.org-repo:
  pkg.installed:
    - sources:
      {% if pgshortversion == '92' %}
      - pgdg-centos{{ pgshortversion }}: http://yum.postgresql.org/{{ pgversion }}/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm
      {% elif pgshortversion == '93' %}
      - pgdg-centos{{ pgshortversion }}: http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
      {% endif %}
    - require_in:
      - pkg: postgresql-packages

postgresql-packages:
  pkg.installed:
    - pkgs:
      - postgresql{{ pgshortversion }}
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
         conn: 100
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
    - require:
      - file: /var/lib/pgsql/{{ pgversion }}/data/postgresql.conf
      - file: /var/lib/pgsql/{{ pgversion }}/data/pg_hba.conf

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
