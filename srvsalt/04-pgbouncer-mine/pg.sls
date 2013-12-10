postgresql_setup:
  salt.state:
    - tgt: 'minion2*'
    - highstate: True

pgbouncer_setup:
  salt.state:
    - tgt: 'minion1*'
    - highstate: True

client_setup:
  salt.state:
    - tgt: '*'
    - highstate: True
