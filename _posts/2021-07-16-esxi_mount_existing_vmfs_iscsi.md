---
layout: post
title: "ESXI Mount existing VMFS ISCSI"
comments: true
date: "2021-07-16 14:39:59.049000+00:00"
---


https://community.spiceworks.com/topic/2256622-mount-existing-datastore-on-iscsi-vmfs-partition-in-esxi-6-7

https://serverfault.com/questions/784375/vm-inaccessible



### mount vmfs partition in esxi

https://serverfault.com/questions/998817/mount-vmfs-partition-in-esxi

```
[root@esxi6:~] esxcfg-volume  -l
Scanning for VMFS-6 host activity (4096 bytes/HB, 1024 HBs).
VMFS UUID/label: 5fd23c30-16acc074-006d-d09466c6d6af/esxi6-flash-ds
Can mount: Yes
Can resignature: Yes
Extent name: naa.6589cfc0000003c710fbb298e0d059e7:1     range: 0 - 511743 (MB)

[root@esxi6:~] esxcli storage vmfs snapshot list
5fd23c30-16acc074-006d-d09466c6d6af
   Volume Name: esxi6-flash-ds
   VMFS UUID: 5fd23c30-16acc074-006d-d09466c6d6af
   Can mount: true
   Reason for un-mountability: 
   Can resignature: true
   Reason for non-resignaturability: 
   Unresolved Extent Count: 1
   
[root@esxi6:~] esxcli storage vmfs snapshot mount -u 5fd23c30-16acc074-006d-d09466c6d6af
```
