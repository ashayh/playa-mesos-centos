# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']

VAGRANTFILE_API_VERSION = 2

zks_ips=[]

nodes_config.each do |node|
  node_name   = node[0] # name of node
  node_values = node[1] # content of node
  if node_name.match(/^mesos.*/)
    zks_ips << node_values[':ip']
  end
end
zkstring =  "zk://" + zks_ips.join(':2181,')
zkstring = zkstring + ":2181/mesos"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    config.vm.box = node_values[":box"]

    config.vm.define node_name do |config|
      # configures all forwarding ports in JSON array
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
          host:  port[':host'],
          guest: port[':guest'],
          id:    port[':id']
      end

      config.vm.hostname = node_name
      config.vm.network :private_network, ip: node_values[':ip']

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", node_values[':memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
      end

      config.vm.provision :shell, :path => node_values[':bootstrap']
      config.vm.provision :shell do |shell|
        if node_name.match(/^slave.*/)
          shell.path = "lib/scripts/common/mesos-slave"
        else
          shell.path = "lib/scripts/common/mesos-master"
        end
        shell.args = "#{zkstring} #{node_values[':ip']}"
      end
      config.vm.provision :shell, inline: "sudo ifdown enp0s8 ; sudo ifup enp0s8"
    end
  end
end
