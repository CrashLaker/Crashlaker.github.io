---
layout: post
title: "MPI Issues"
comments: true
date: "2021-07-13 08:27:07.158000+00:00"
---

##  “Read -1, expected 48, errno = 1”

https://www.mail-archive.com/search?l=users@lists.open-mpi.org&q=subject:%22%5C%5BOMPI+users%5C%5D+Help%22&o=newest&f=1

```
“Read -1, expected 48, errno = 1”
```


```bash
docker run -it --rm \
           --privileged \
           --security-opt label=disable \
           --security-opt seccomp=unconfined \
		   --security-opt apparmor=unconfined \
		   --ipc=host \
		   centos:7 bash
```

```yaml
cluster2node04:
    image: crashlaker/master138
    privileged: true
    shm_size: 64M
    command: "/usr/sbin/sshd -D"
    hostname: cluster2node04
    volumes:
        - /root/mcmpi:/code
    deploy:
        replicas: 1
        resources:
            limits:
                cpus: '4'
                memory: 8G
            reservations:
                cpus: '4'
                memory: 8G
    ulimits:
        nproc: 65535
        memlock:
            soft: -1
            hard: -1 
        stack:
            soft: -1 
            hard: -1
    networks: 
        - cluster2_comm
```











