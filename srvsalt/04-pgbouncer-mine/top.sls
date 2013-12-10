base:
  '*':
    - epel
    - users
    - postgresql.repo
    - postgresql.client

  'minion1*':
    - pgbouncer
    - postgresql.client
    - postgresql.firewall

  'minion2*':
    - postgresql
    - postgresql.client
    - postgresql.firewall

