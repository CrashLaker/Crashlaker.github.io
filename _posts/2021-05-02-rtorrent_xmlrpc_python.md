---
layout: post
title: "rTorrent xmlrpc python"
comments: true
date: "2021-05-02 15:10:58.786000+00:00"
---


source code:
https://github.com/Novik/ruTorrent/blob/44d43229f07212f20b53b6301fb25882125876c3/plugins/httprpc/action.php#L94

https://rtorrent-docs.readthedocs.io/en/latest/cmd-ref.html

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


```python
thash = "E72517382011ED37CE7D1243CE8125FE16EA263A"
print(server.d.get_ratio(thash))
print(server.d.get_up_rate(thash))
print(server.d.get_left_bytes(thash))
print(server.d.get_state(thash))
print(server.d.get_state_changed(thash))
```


#### Delete torrent

```
url = "https://<your-seedbox>/rutorrent/plugins/httprpc/action.php"
payload = '<?xml version="1.0" encoding="UTF-8"?><methodCall><methodName>system.multicall</methodName><params><param><value><array><data><value><struct><member><name>methodName</name><value><string>d.custom5.set</string></value></member><member><name>params</name><value><array><data><value><string>TORRENT_HASH</string></value><value><string>1</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.delete_tied</string></value></member><member><name>params</name><value><array><data><value><string>TORRENT_HASH</string></value></data></array></value></member></struct></value><value><struct><member><name>methodName</name><value><string>d.erase</string></value></member><member><name>params</name><value><array><data><value><string>TORRENT_HASH</string></value></data></array></value></member></struct></value></data></array></value></param></params></methodCall>'
thash = "BEC5A34A3F98A685E3907B0658DC3FEAC01E1FF0"
payload = payload.replace("TORRENT_HASH",
                          thash)
rs = requests.post(url, data=payload, auth=(user, password))
rs.text
```

