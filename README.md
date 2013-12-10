saltstack-talk-examples
=======================

Some examples to use with my Saltstack talk.

These examples are somewhat Centos6 specific.

This repo contains a Vagrantfile which will fire up 3 hosts:
salt,minion1, and minion2.

They are essentially bare Centos6 boxes waiting to have 
salt installed and a demonstration run.

If you're using vmware_fusion on your Mac, you should be able to
just git clone this repo, cd into it and then:
```
vagrant up --provider=vmware_fusion
```

If you're using virtualbox on any other platform, you'll need
to import a centos6 base box from: http://www.vagrantbox.es/

Finally, the srvsalt directory contains snapshots of 
the /srv/salt directory at different points in the talk.

For example: srvsalt/01-users-only contains a basic
salt state which will install a single user with an 
initial password of "password"

The srvpillar directory contains snapshots of the
/srv/pillar directory at different points in the talk.

Finally, etc-salt contains a fileserver config to enable
gitfs for a basic formula. As you might guess, you would 
copy that to /etc/salt.
