# Playa Mesos

This is rewrite of [playa-mesos](https://github.com/mesosphere/playa-mesos) from ubuntu to centos 7

This guide is made for OS X, but may work with changes on Linux.

The Vagrant box image can be downloaded here:  http://107.170.206.223/playa_mesos_centos-7.1-virtualbox.box

[Playa Mesos][8] helps you quickly create [Apache Mesos][1] test environments.
This project relies on [VirtualBox][5], [Vagrant][6], and an Ubuntu box image
which has Mesos and [Marathon][2] pre-installed. The box image is downloadable for your
convenience, but it can also be built from source using [Packer][9].

This vagrant project will bring up 7 total VMs: 3 mesos masters and 4 slaves. Each VM uses 684MB of Ram, so you better have enough :)
The 3 masters can also be converted to master + slaves

The definitions for the hostnames and IPs for these VMS exist in ```nodes.json```

Vagrants ```hostmanager``` plugin will add hosts file entries in ```/etc/hosts```
This step *may* ask for your sudo password.

Once hosts entries are added, you can directly use the hostnames of the VMs in your local machine.

## Requirements

* [VirtualBox][5] 4.2+
* [Vagrant][6] 1.3+
* [git](http://git-scm.com/downloads) (command line tool)
* [Vagrant Hostmanager plugin](https://github.com/smdahlen/vagrant-hostmanager) (required)
* [Packer][9] 0.5+ (optional)

## Quick Start

1. [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads) or use brew to install virtualbox as shown below.

1. [Install Vagrant](http://www.vagrantup.com/downloads.html) or use brew to install Vagrant as shown below.

1. Install all required or optional tools, then clone this repository:

  ```bash

  ###### Use brew http://brew.sh/ to install vagrant & virtualbox

  # using brew is not required, you can install with your favorite method
  brew tap phinze/homebrew-cask
  brew install brew-cask
  brew cask install vagrant
  brew cask install virtualbox

  ###### these vagrant plugins are *required*
  ###### Note: hostsmanager adds hosts in /etc/hosts & ot may ask for a password

  vagrant plugin install vagrant-berkshelf
  vagrant plugin install vagrant-hostmanager
  vagrant plugin install vagrant-share
  vagrant plugin install vagrant-vbguest

  # clone this repository
  git git@github.com:ashayh/playa-mesos-centos.git
  cd playa-mesos-centos
  ```
1. Start the VMs, this will bring up 7 Vms sequentially:

  ```bash
  vagrant up
  ```

1. Connect to the Mesos Web UI on [http://mesos1.example.com:5050](http://mesos1.example.com:5050) and the Marathon Web UI on [mesos1.example.com:8080](http://mesos1.example.com:8080)

You may be redirected to the mesos master that is currently the 'leader' node.

There is an example tomcat app that can be deployed using Mesos.

To deploy that app, run the ```curl_cmds.sh``` script, which will deploy 2 instances of tomcat on any 2 slaves.

You can then experiment with any of the mesos/marathon features like:
 * Kill tomcat from any slave and see it pop up again instantly, often on another slave.
 * Scale tomcat to 4 instances (the constraint in ```tomcat-testapp.json``` limits it to 1 instance per VM, which you can change)
 * Play with the various APIs.

1. SSH to the VM

  ```bash
  vagrant ssh mesos1.example.com
  ps -eaf | grep mesos
  exit
  ```

1. Halt the VM

  ```bash
  vagrant halt
  vagrant halt slave1.example.com        # halt only one slave
  ```

1. Destroy the VM

  ```bash
  vagrant destroy
  vagrant destroy slave3.example.com     # destroy only one slave
  ```

## Building the Mesos box image (optional)

1. Install [Packer][9]

  Installing Packer is not completely automatic. Once you have downloaded and
  extracted Packer, you must update your search path so that the `packer`
  executable can be found.

  ```bash
  # EXAMPLE - PACKER LOCATION MUST BE ADJUSTED
  export PATH=$PATH:/path/where/i/extracted/packer/archive/
  ```

1. Destroy any existing VM

  ```bash
  vagrant destroy
  ```

1. Build the Vagrant box image

  ```bash
  # the build command will use run packer, which will use ```packer-virtualbox.json``` as input
  # this json file has hard coded IP address. CHANGE it to your local machines main IP address
  # The kickstart file can then be served over HTTP for example by python:

  cd packer && python -m SimpleHTTPServer

  # Optionally change the kickstart or the scripts run by packer to configure the new box
  # then buile the box:
  bin/build     # build the packer box
  ```
1. Add the packer box to vagrant:

  ```bash
  vagrant box add packer/builds/playa_mesos_centos-7.1-virtualbox.box --name playa_mesos_centos-7.1-virtualbox
  ```

1. Change the default VM name in nodes.json, then start the VM using the local box image

  ```bash
  vagrant up
  ```

The build is controlled with the following files:

* [nodes.json][21]
* [packer/packer-virtualbox.json][22]
* [lib/scripts/][23]

For additional information on customizing the build, or creating a new profile,
see [Configuration][15] and the [Packer Documentation][20].

## Documentation

* [Configuration][15]
* [Common Tasks][16]
* [Troubleshooting][17]
* [Known Issues][18]
* [To Do][19]

## Similar Projects

* [vagrant-mesos](https://github.com/everpeace/vagrant-mesos): Vagrant
  provisioning with multinode and EC2 support

## Author of this project:
* [Ashay Humane](https://github.com/ashayh)

## Authors of the original playa-mesos:

* [Jeremy Lingmann](https://github.com/lingmann) ([@lingmann](https://twitter.com/lingmann))
* [Jason Dusek](https://github.com/solidsnack) ([@solidsnack](https://twitter.com/solidsnack))

VMware Support: [Fabio Rapposelli](https://github.com/frapposelli) ([@fabiorapposelli](https://twitter.com/fabiorapposelli))


[1]: http://incubator.apache.org/mesos/ "Apache Mesos"
[2]: http://github.com/mesosphere/marathon "Marathon"
[3]: http://jenkins-ci.org/ "Jenkins"
[4]: http://zookeeper.apache.org/ "Apache Zookeeper"
[5]: http://www.virtualbox.org/ "VirtualBox"
[6]: http://www.vagrantup.com/ "Vagrant"
[7]: http://www.ansibleworks.com "Ansible"
[8]: https://github.com/mesosphere/playa-mesos "Playa Mesos"
[9]: http://www.packer.io "Packer"
[13]: http://mesosphere.io/downloads "Mesosphere Downloads"
[14]: http://www.ubuntu.com "Ubuntu"
[15]: doc/config.md "Configuration"
[16]: doc/common_tasks.md "Common Tasks"
[17]: doc/troubleshooting.md "Troubleshooting"
[18]: doc/known_issues.md "Known Issues"
[19]: doc/to_do.md "To Do"
[20]: http://www.packer.io/docs "Packer Documentation"
[21]: config.json "config.json"
[22]: packer/packer.json "packer.json"
[23]: lib/scripts "scripts"
