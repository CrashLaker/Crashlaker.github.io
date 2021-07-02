---
layout: post
title: "CentOS First Install"
comments: true
date: "2021-07-01 04:59:24.359000+00:00"
---

```bash
yum -y install epel-release
yum -y install vim git htop wget curl python3
pip3 install -U pip
pip3 install docker-compose
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
systemctl mask firewalld
systemctl enable docker
wget "https://github.com/CrashLaker/plainrepo/raw/master/myvim%20(4).rpm" -O /tmp/myvim.rpm
yum -y install /tmp/myvim.rpm && rm -f /tmp/myvim.rpm

ssh-keygen -t rsa -q -N "" -f /root/.ssh/id_rsa
ssh-keygen -t ed25519 -q -N "" -f /root/.ssh/id_ed25519
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO5iNgGl6AWSPoarhHPnpAtDg3lYAaQG/tVs7MLiuvq root@automation" >> /root/.ssh/authorized_keyskj
```