---
layout: post
title: "Edgerouter load balancer"
comments: true
date: "2021-08-15 05:11:59.724000+00:00"
---


![](/assets/img/FYUmgQZk__59aa8b76c051ed5e02391ba9b5dcd7b4.png)

https://blog.earth-works.com/2015/01/21/lan-to-lan-routing-with-ubiquiti-edgerouter-dual-wan/

```
configure
set firewall group network-group LAN_NETWORKS network 10.6.0.0/16
set firewall group network-group LAN_NETWORKS network 10.7.0.0/16
commit

configure
show firewall modify
delete firewall modify balance rule 1

set firewall modify balance rule 10 destination group network-group LAN_NETWORKS
set firewall modify balance rule 10 action modify
set firewall modify balance rule 10 modify table main

set firewall modify balance rule 20 action modify
set firewall modify balance rule 20 modify lb-group G
commit
```

<iframe width="612" height="344" src="https://www.youtube.com/embed/1J475E-0rIU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>