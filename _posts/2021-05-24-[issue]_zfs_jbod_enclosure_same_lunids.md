---
layout: post
title: "[Issue] ZFS JBOD Enclosure same LUNIDs"
comments: true
date: "2021-05-24 18:16:44.853000+00:00"
---



https://www.truenas.com/community/threads/add-new-storage-pool-not-showing-usb-jbod-box-drives.93259/#post-645425


![](/assets/img/xa0PNvQ7A_20082fe14834aba0672bcfb76d5caadf.png)



https://forums.freebsd.org/threads/how-find-numeric-id-of-drive-zfs.62475/
```shell
geom disk list
camcontrol devlist
camcontrol identify da0
glabel list
```



https://forums.freebsd.org/threads/labeling-partitions-done-right-on-modern-computers.69250/

```shell
gpart destroy -F da6
gpart create -s gpt da6
gpart add -t freebsd-zfs -l oricoA-labelX da6
# or
gpart create -s gpt da7
gpart add -t freebsd-zfs da7
gpart modify -i1 -l oricoA-labelY da7

zpool create -f <poolname> raidz1 /dev/gpt/oricoA-*
```