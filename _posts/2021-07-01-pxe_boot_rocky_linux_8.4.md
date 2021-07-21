---
layout: post
title: "PXE Boot Rocky Linux 8.4"
comments: true
date: "2021-07-01 13:30:55.755000+00:00"
---


https://www.lisenet.com/2021/install-and-configure-a-pxe-boot-server-for-kickstart-installation-on-centos/

https://www.lisenet.com/2021/configure-pxe-boot-server-for-rocky-linux-8-kickstart-installation/

https://www.lisenet.com/2021/install-and-configure-a-pxe-boot-server-for-kickstart-installation-on-centos/


# Install 

First boot

## VSFTP

```bash
sudo yum install vsftpd -y
sudo systemctl enable vsftpd

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bk

cat <<EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=YES
local_enable=NO
write_enable=NO
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ftpd_banner=Welcome to homelab FTP service.
listen=YES
listen_ipv6=NO
listen_port=21
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=NO
pasv_enable=YES
pasv_address=10.6.0.1
#pasv_address=192.168.31.217
pasv_min_port=60000
pasv_max_port=60029
EOF

sudo systemctl start vsftpd
```

## TFTP

```
yum -y install tftp-server
systemctl enable tftp && sudo systemctl start tftp
```

### ISO

```
curl -# -O https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-dvd1.iso
```

```
mkdir -p /mnt/iso /var/ftp/pub/pxe/Rocky8
mount Rocky-8.4-x86_64-dvd1.iso /mnt/iso
cp -prv /mnt/iso/* /var/ftp/pub/pxe/Rocky8/
umount /mnt/iso
```

Verify:
```
curl ftp://10.6.0.1/pub/pxe/Rocky8/
dr-xr-xr-x    4 0        0              38 Jun 20 16:15 AppStream
dr-xr-xr-x    4 0        0              38 Jun 20 16:15 BaseOS
dr-xr-xr-x    3 0        0              18 Jun 20 16:15 EFI
-r--r--r--    1 0        0            2204 Jun 19 14:22 LICENSE
-r--r--r--    1 0        0             883 Jun 20 16:15 TRANS.TBL
dr-xr-xr-x    3 0        0              76 Jun 20 16:15 images
dr-xr-xr-x    2 0        0             256 Jun 20 16:15 isolinux
-r--r--r--    1 0        0              86 Jun 20 16:13 media.repo
```

## Interface

`/etc/sysconfig/network-scripts/ifcfg-ens224`

```bash
DEVICE=ens224
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.6.0.1
NETMASK=255.255.0.0
GATEWAY=10.6.0.1
```

## DHCP
https://www.lisenet.com/2018/configure-dhcp-failover-with-dynamic-dns-on-centos-7/

```bash
yum -y install dhcp-server
systemctl enable dhcpd
```

`/etc/dhcp/dhcpd.conf`
```
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
#authoritative;
allow booting;
allow bootp;
next-server 10.6.0.1; # Katello TFTP
filename "pxelinux.0";
#default-lease-time 86400; # 1 day
#max-lease-time 86400; # 1 day
default-lease-time -1;
max-lease-time -1;

ddns-update-style interim;

update-static-leases on;
one-lease-per-client on;

subnet 10.6.0.0 netmask 255.255.0.0 {
  option subnet-mask 255.255.0.0;
  option broadcast-address 10.6.0.255;
  option routers 10.6.0.1;
  #option domain-name-servers dns1.hl.local, dns2.hl.local;
  option domain-search "pxe.local", "pxe2.local";
  range 10.6.0.10 10.6.0.200;
}
```

```
chmod 0600 /etc/dhcp/dhcpd.conf
dhcpd -t -cf /etc/dhcp/dhcpd.conf # test
systemctl restart dhcpd
```

## Rocky 8.4 Kickstart

`/var/ftp/pub/pxe/rocky8-ks.cfg`

```
#version=RHEL8
# https://access.redhat.com/labs/kickstartconfig/
# System authorisation information
auth --useshadow --passalgo=sha512
# Use network installation
url --url="ftp://10.6.0.1/pub/pxe/Rocky8/BaseOS"
repo --name="AppStream" --baseurl=ftp://10.6.0.1/pub/pxe/Rocky8/AppStream

# Use graphical install
graphical
# Keyboard layouts
#keyboard --vckeymap=gb --xlayouts='gb'
# System language
#lang en_GB.UTF-8
lang en_US.UTF-8
# Keyboard layouts
keyboard --xlayouts='us'
# SELinux configuration
#selinux --enforcing
selinux --disabled
# Firewall configuration
firewall --enabled --ssh
firstboot --disable

# Network information
network  --bootproto=dhcp --device=ens192 --nameserver=10.0.0.1,192.168.31.100,192.168.31.1 --noipv6 --activate
# Reboot after installation
reboot
ignoredisk --only-use=sda

# Root password
#rootpw --iscrypted $6$7YZ0gnLkLPrl6rRO$NTjTQx1nesw5JLjtiAVdn3UBSbahUBGDFSiGGfrMNfGBum5aFs.TQcNX1SEuoWX/TmQ/ZMfiMnyHDs9uu9VH9.
# Root password                                                                 
rootpw --iscrypted $6$D.nxjylX.25Ce0bc$iWZARl5wZGsmLKWRSx0VAJKI6EGB7gl3jvqaL06xdQYbCBpH94c921VgI.cDiM6kdza5N.36nVyowuaQOQqh4.
# System timezone
timezone America/Sao_Paulo --isUtc
# System bootloader configuration
#bootloader --location=mbr --timeout=1 --boot-drive=vda
# Clear the Master Boot Record
#zerombr
# Partition clearing information
#clearpart --all --initlabel

# Disk partitioning information
#autopart --type=lvm
#part /boot --fstype="xfs" --ondisk=vda --size=1024 --label=boot --asprimary
#part pv.01 --fstype="lvmpv" --ondisk=vda --size=15359
#volgroup vg_os pv.01
#logvol /tmp  --fstype="xfs" --size=1024 --label="lv_tmp" --name=lv_tmp --vgname=vg_os
#logvol /  --fstype="xfs" --size=14331 --label="lv_root" --name=lv_root --vgname=vg_os

# Partition clearing information
#clearpart --none --initlabel
clearpart --all
# Disk partitioning information
part pv.603 --fstype="lvmpv" --ondisk=sda --size 1 --grow
part /boot --fstype="xfs" --ondisk=sda --size=1024
volgroup rl pv.603
logvol / --fstype="ext4" --grow --percent=100 --name=root --vgname=rl

#part pv.603 --fstype="lvmpv" --ondisk=sda --size=39935
#part /boot --fstype="xfs" --ondisk=sda --size=1024
#volgroup rl --pesize=4096 pv.603
#logvol / --fstype="ext4" --grow --percent=90 --name=root --vgname=rl

%post
touch /etc/lalala
chmod +x /etc/rc.local
chmod +x /etc/rc.d/rc.local
cp /etc/rc.local /etc/rc.local.bk
curl ftp://10.6.0.1/pub/kickstart.sh > /root/kickstart.sh
echo "reboot" >> /root/kickstart.sh
echo "nohup bash -x /root/kickstart.sh 2>&1 | tee /tmp/kickstart.log &" >> /etc/rc.local
echo "cp /etc/rc.local.bk /etc/rc.local" >> /etc/rc.local

%end 


%packages
@^minimal-environment

%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
```

```bash
mkdir -p /var/lib/tftpboot/networkboot/Rocky8
cp -pv /var/ftp/pub/pxe/Rocky8/images/pxeboot/{initrd.img,vmlinuz} /var/lib/tftpboot/networkboot/Rocky8/
```


```
yum install syslinux -y
cp -prv /usr/share/syslinux/* /var/lib/tftpboot/
```

```bash
[ ! -d /var/lib/tftpboot/pxelinux.cfg ] && mkdir /var/lib/tftpboot/pxelinux.cfg
#/var/lib/tftpboot/pxelinux.cfg/default
```

```bash
default menu.c32
prompt 0
timeout 30
menu title Homelab PXE Menu
label Install Rocky 8.4 Server
  kernel /networkboot/Rocky8/vmlinuz
  append initrd=/networkboot/Rocky8/initrd.img inst.repo=ftp://10.6.0.1/pub/pxe/Rocky8 ks=ftp://10.6.0.1/pub/pxe/rocky8-ks.cfg
```


## ESXI Config

![](/assets/img/F4xIVHgdH_f5ecb37664fb50d0861a779a554ceb68.png)

![](/assets/img/F4xIVHgdH_fb960da12f51f1461d5593657398aa4c.png)




## Bastion Host NAT

https://askubuntu.com/questions/898473/nat-using-iptables-on-ubuntu-16-04-doesnt-work

```
sysctl -a | grep forwarding
[root@bastion ~]# sysctl -a | grep forwarding
net.ipv4.conf.all.bc_forwarding = 0
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.all.mc_forwarding = 0
net.ipv4.conf.default.bc_forwarding = 0
net.ipv4.conf.default.forwarding = 1
net.ipv4.conf.default.mc_forwarding = 0
net.ipv4.conf.docker0.bc_forwarding = 0
net.ipv4.conf.docker0.forwarding = 1
net.ipv4.conf.docker0.mc_forwarding = 0
net.ipv4.conf.ens192.bc_forwarding = 0
net.ipv4.conf.ens192.forwarding = 1
net.ipv4.conf.ens192.mc_forwarding = 0
net.ipv4.conf.ens224.bc_forwarding = 0
net.ipv4.conf.ens224.forwarding = 1
net.ipv4.conf.ens224.mc_forwarding = 0
```

```
sudo iptables -A FORWARD -o eth0 -j ACCEPT
sudo iptables -A FORWARD -m state \
--state ESTABLISHED,RELATED -i eth0 -j ACCEPT
```

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```


`rc.local`

```

iptables -A FORWARD -o ens192 -j ACCEPT
iptables -A FORWARD -m state --state ESTABILISHED,RELATED -i ens192 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -i ens192 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens192 -j MASQUERADE
iptables -A FORWARD -o ens224 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -i ens224 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens224 -j MASQUERADE

touch /var/lock/subsys/local
```
















