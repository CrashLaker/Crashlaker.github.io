---
layout: post
title: "Vagrant Study"
comments: true
date: "2021-08-10 16:57:51.764000+00:00"
---

https://app.vagrantup.com/geerlingguy/boxes/centos7
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
end
```

* **Interesting**
    * https://www.vagrantup.com/docs/provisioning/basic_usage

### Download Vagrant
https://www.vagrantup.com/downloads
```bash
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install vagrant
```


### Multiple machines
https://manski.net/2016/09/vagrant-multi-machine-tutorial/

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Every Vagrant development environment requires a box. You can search for
# boxes at https://atlas.hashicorp.com/search.
BOX_IMAGE = "bento/ubuntu-16.04"
NODE_COUNT = 2

Vagrant.configure("2") do |config|
  config.vm.define "master" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "master"
    subconfig.vm.network :private_network, ip: "10.0.0.10"
  end
  
  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "node#{i}"
      subconfig.vm.network :private_network, ip: "10.0.0.#{i + 10}"
    end
  end

  # Install avahi on all machines  
  config.vm.provision "shell", inline: <<-SHELL
    apt-get install -y avahi-daemon libnss-mdns
  SHELL
end
```


**Commands**

```bash

```

**Package**

https://stackoverflow.com/questions/17853850/vagrant-vm-not-created-when-trying-to-create-box-from-existing-vm

https://www.vagrantup.com/docs/boxes/base

```
$ vboxmanage list vms
"base_default_1628627951186_43834" {118d1929-fe05-461f-b6f8-d07702f7b930}
"controller" {5324bfae-8f8b-4ace-8e17-f85768d22fae}
"base2_default_1628636294170_27649" {c57ed90d-b1ac-416f-b970-0dd17d9d550d}

$ vagrant package <?name> --output centos7master.box
$ vagrant box add --name centos7master ./centos7master.box
$ vagrat box list
centos/7           (virtualbox, 2004.01)
centos7-masters138 (virtualbox, 0)
centos7master      (virtualbox, 0)
```

### Caveats

#### ValueError: File context for /opt/VBoxGuestAdditions-6.1.26/other/mount.vboxsf already defined

https://www.reddit.com/r/virtualbox/comments/gabkpr/vb_guest_additions_install_issue_on_fedora_32/



