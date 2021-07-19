---
layout: post
title: "My Codeserver Instance"
comments: true
date: "2020-04-15 20:02:49.933000+00:00"
categories:  [development]
tags:  [docker,codeserver,codesk]
---



```yaml
version: '3'
services:
  codeserver:
    image: crashlaker/mycodeserver:v1
    restart: always
    volumes:
      - ./data:/home/coder/project
    ports:
      - 8081:8080 # live server
      - 8444:8443 # dev server
      - 9091:9090 # back server
    command: ["-config.file", "/config.yaml"]
```



`codercom/code-server --allow-http --auth none --port 8443`

```bash
args="d3js:8445:8082"
codeserver_name=$( echo $args | cut -d: -f1)
codeserver_ide=$( echo $args | cut -d: -f2)
codeserver_live=$( echo $args | cut -d: -f3)
label="codeserver_${codeserver_name}"
folder="/root/$label"
[ ! -d $folder ] && mkdir $folder 
chmod -R 777 $folder
docker rm -f $label
docker run -dit --name $label \
        --restart always \
        -p $codeserver_ide:8443 \
        -p $codeserver_live:8080 \
        -v $folder:/home/coder/project \
        crashlaker/mycodeserver:v1
```



### Known Caveats
https://github.com/cdr/code-server/issues/1370
Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at https://v1.extapi.coder.com/extensionquery. (Reason: CORS request did not succeed)