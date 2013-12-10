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

# So we're going to just stop the iptables service for our demo
iptables:
  service.dead:
    - enable: False
