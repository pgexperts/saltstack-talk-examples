#!/bin/bash

salt '*' saltutil.sync_modules
# Sometimes the puppetlabs repo is unreachable and we don't need it, it 
# just came with this base box
salt '*' cmd.run 'sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/puppetlabs.repo'
sleep 3
salt-run state.over
