require 'ipaddr'

# Make sure you: vagrant plugin install vagrant-hostmanager

VAGRANTFILE_API_VERSION = "2"
CONFIGURATION = {
  domain: 'example.com',
  box: 'centos63',
  box_url: 'https://dl.dropbox.com/u/5721940/vagrant-boxes/vagrant-centos-6.4-x86_64-vmware_fusion.box',
  starting_ip_address: '10.40.1.30',
  vms: [
    {
      name: :salt,
      primary: true,
      hostname: 'salt.example.com',
    },
    {
      name: :minion1,
      primary: false,
      hostname: 'minion1.example.com',
    },
    {
      name: :minion2,
      primary: false,
      hostname: 'minion2.example.com',
    }
  ]
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = CONFIGURATION[:box]
  config.vm.box_url = CONFIGURATION[:box_url]

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  ip_address = IPAddr.new(CONFIGURATION[:starting_ip_address])
  CONFIGURATION[:vms].each do |vm|
    vm[:ip_address] = ip_address.to_s
    ip_address = ip_address.succ
  end

  CONFIGURATION[:vms].each do |vm|
    config.vm.define vm[:name], primary: vm[:primary] do |vagrant_vm|
      vagrant_vm.vm.box = CONFIGURATION[:box]
      vagrant_vm.vm.box_url = CONFIGURATION[:box_url]

      vagrant_vm.vm.hostname = vm[:hostname]
      vagrant_vm.vm.network :private_network, ip: vm[:ip_address]
      vagrant_vm.hostmanager.aliases = ["#{vm[:name]}"]

    end
  end

end
