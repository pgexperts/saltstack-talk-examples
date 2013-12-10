postgresql:
  match: 'minion2*'
  sls:
    - postgresql.firewall
    - postgresql.repo
    - postgresql
    - postgresql.client
pgbouncer:
  match: 'minion1*'
  sls:
    - postgresql.firewall
    - postgresql.repo
    - pgbouncer
    - postgresql.client
  require:
    - postgresql
all:
  match: '*'
  require:
    - postgresql
    - pgbouncer
