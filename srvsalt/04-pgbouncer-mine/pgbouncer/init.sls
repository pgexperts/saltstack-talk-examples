
pgbouncer-pkgs:
  pkg.installed:
    - pkgs:
      - libevent
      - compat-libevent14
      - pgbouncer
      - python-psycopg2
    - require:
      - pkg: postgresql.org-repo

{% for host, value in salt['mine.get']('roles:' + 'postgresql_server', 'grains.items', expr_form = 'grain').items() %}
{% set postgresql_server_ip = value.ip_interfaces['eth1'][0] %}

/etc/pgbouncer/pgbouncer.ini:
  file.managed:
    - source: salt://pgbouncer/pgbouncer.ini.jinja
    - template: jinja
    - user: pgbouncer
    - group: root
    - mode: 640
    - context:
        postgresql_server_ip: {{ postgresql_server_ip }}
    - require:
      - pkg: pgbouncer-pkgs

/etc/pgbouncer/userlist.txt:
  file.managed:
    - replace: False
    - user: pgbouncer
    - group: root
    - mode: 640
    - require:
      - pkg: pgbouncer-pkgs

update-userlist:
  cmd.wait:
  - name: python /etc/pgbouncer/mkauth.py /etc/pgbouncer/userlist.txt "host={{ postgresql_server_ip }} user=postgres"
  - user: root
  - watch:
    - file: /etc/pgbouncer/pgbouncer.ini
  - require:
    - file: /etc/pgbouncer/userlist.txt

update-userlist-cron:
  cmd.wait:
  - name: python /etc/pgbouncer/mkauth.py /etc/pgbouncer/userlist.txt "host={{ postgresql_server_ip }} user=postgres"
  - user: root
  - hour: 0

{% endfor %}

roles:
  grains.present:
    - value: pgbouncer_server

pgbouncer:
  service:
    - running
    - watch:
      - file: /etc/pgbouncer/pgbouncer.ini
