---
layout: post
title: "Grafana Tempo Study"
comments: true
date: "2021-06-30 23:00:01.999000+00:00"
---




https://grafana.com/docs/tempo/latest/api_docs/pushing-spans-with-http/


![](/assets/img/Pfi2w4LqP_af77a2554d7a629dc7c328f56e422d2e.png)

![](/assets/img/Pfi2w4LqP_cdd87dea76d070361c028810020e663c.png)


```
[root@grafana-tempo tempo]# curl -X POST http://localhost:9411 -H 'Content-Type: application/json' -d '[{
>  "id": "1234",
>  "traceId": "0123456789abcde0",
>  "timestamp": 1625115600000000,
>  "duration": 200000,
>  "name": "span from bash!",
>  "tags": {
>     "http.method": "GET",
>     "http.path": "/api"
>   },
>   "localEndpoint": {
>     "serviceName": "shell script"
>   }
> }]'
[root@grafana-tempo tempo]# curl -X POST http://localhost:9411 -H 'Content-Type: application/json' -d '[{
>  "id": "5678",
>  "traceId": "0123456789abcde0",
>  "parentId": "1234",
>  "timestamp": 1625115610000000,
>  "duration": 150000,
>  "name": "child span from bash!",
>   "localEndpoint": {
>     "serviceName": "shell script"
>   }
> }]'
[root@grafana-tempo tempo]# curl -X POST http://localhost:9411 -H 'Content-Type: application/json' -d '[{
>  "id": "6789",
>  "traceId": "0123456789abcde0",
>  "parentId": "5678",
>  "timestamp": 1625115610100000,
>  "duration": 350000,
>  "name": "child span from bash!",
>   "localEndpoint": {
>     "serviceName": "shell script"
>   }
> }]'
```







