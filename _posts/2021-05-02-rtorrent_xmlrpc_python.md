---
layout: post
title: "rTorrent xmlrpc python"
comments: true
date: "2021-05-02 15:10:58.786000+00:00"
---


source code:
https://github.com/Novik/ruTorrent/blob/44d43229f07212f20b53b6301fb25882125876c3/plugins/httprpc/action.php#L94

```python
import xmlrpc.client

#https://whatbox.ca/wiki/Using_XMLRPC_with_Python


server_url = f"https://{user}:{password}@my.seedbox.url:443/RPC2"
server = xmlrpc.client.Server(server_url)
```

```python
len(server.download_list("", "main"))
751
len(server.download_list("", "started"))
127
len(server.download_list("", "stopped"))
624
len(server.download_list("", "hashing"))
0
len(server.download_list("", "seeding"))
109
len(server.download_list("", "active"))
127
len(server.download_list("", "leeching"))
18
```

```python
d = server.get_down_rate()
d/1024**2
11.092472076416016
---
u = server.get_up_rate()
print(u)
print(u/1024**2)
17086143
16.294615745544434
server.get_down_total()
694536239401
server.get_up_total()
2601888384060
len(server.download_list())
751
get_memory_usage
server.get_memory_usage()
1588592640
1588592640/1024**2
1515.0
```
