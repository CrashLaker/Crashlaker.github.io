---
layout: post
title: "ZFS Cheat Sheet"
comments: true
date: "2021-05-25 00:58:03.877000+00:00"
---

## Utils

https://forums.freebsd.org/threads/how-find-numeric-id-of-drive-zfs.62475/

```shell
geom disk list
camcontrol devlist
camcontrol identify da0
glabel list
zpool get all <poolname>
```

## Partitions

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
zfs set compression=lz4 <poolname>
```

## RAID6 & RAID 10
```shell
zpool create -f data6 raidz2 sda sdb sdc sdd
zpool create -f data10 mirror sda sdb mirror sdc sdd
```

## Replace
```shell
zpool offline <pool> sdl
zpool replace <pool> sdl sdm
```

## Export
```shell
zpool export data10
zpool import
zpool import <pool-name/pool-id>

# import a destroyed pool
zpool destroy data6
zpool import -D data6
```

## Add spare
https://forums.freebsd.org/threads/adding-new-drive-as-a-spare-to-zpool.68196/
```shell
zpool add (pool) spare (disk)
```

## Snapshot & Clone
```shell
zfs snapshot <pool>/<fs>@snap1
zfs clone <pool>/<fs>@snap1 <pool>/<fs2>
```

## Send & Recv

https://docs.oracle.com/cd/E18752_01/html/819-5461/gbchx.html

```shell
zfs send <pool>/<fs>@<snap> | zfs recv <pool2>/<fs>
```

**Send**
```shell
# zfs send tank/data@snap1 | zfs recv spool/ds01
host1# zfs send tank/dana@snap1 | ssh host2 zfs recv newtank/dana
host1# zfs send -i tank/dana@snap1 tank/dana@snap2 | ssh host2 zfs recv newtank/dana
host1# zfs send -i snap1 tank/dana@snap2 > ssh host2 zfs recv newtank/dana
# zfs send pool/fs@snap | gzip > backupfile.gz
```

**Receive**
```shell
# zfs send tank/gozer@0830 > /bkups/gozer.083006
# zfs receive tank/gozer2@today < /bkups/gozer.083006
# zfs rename tank/gozer tank/gozer.old
# zfs rename tank/gozer2 tank/gozer
```













