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


## OpenTracing

https://github.com/opentracing/specification/blob/master/semantic_conventions.md




## Zipkin


### Instrumenting

Annotation

An Annotation is used to record an occurrence in time. There’s a set of core annotations used to define the beginning and end of an RPC request:

* **cs** - Client Send. The client has made the request. This sets the beginning of the span.
* **sr** - Server Receive: The server has received the request and will start processing it. The difference between this and cs will be combination of network latency and clock jitter.
* **ss** - Server Send: The server has completed processing and has sent the request back to the client. The difference between this and sr will be the amount of time it took the server to process the request.
* **cr** - Client Receive: The client has received the response from the server. This sets the end of the span. The RPC is considered complete when this annotation is recorded.

When using message brokers instead of RPCs, the following annotations help clarify the direction of the flow:

* **ms** - Message Send: The producer sends a message to a broker.
* **mr** - Message Receive: A consumer received a message from a broker.


### Data Model

https://zipkin.io/pages/data_model.html

```json
 [
    {
      "traceId": "5982fe77008310cc80f1da5e10147517",
      "name": "get",
      "id": "bd7a977555f6b982",
      "timestamp": 1458702548467000,
      "duration": 386000,
      "localEndpoint": {
        "serviceName": "zipkin-query",
        "ipv4": "192.168.1.2",
        "port": 9411
      },
      "annotations": [
        {
          "timestamp": 1458702548467000,
          "value": "sr"
        },
        {
          "timestamp": 1458702548853000,
          "value": "ss"
        }
      ]
    },
    {
      "traceId": "5982fe77008310cc80f1da5e10147517",
      "name": "get-traces",
      "id": "ebf33e1a81dc6f71",
      "parentId": "bd7a977555f6b982",
      "timestamp": 1458702548478000,
      "duration": 354374,
      "localEndpoint": {
        "serviceName": "zipkin-query",
        "ipv4": "192.168.1.2",
        "port": 9411
      },
      "tags": {
        "lc": "JDBCSpanStore",
        "request": "QueryRequest{serviceName=zipkin-query, spanName=null, annotations=[], binaryAnnotations={}, minDuration=null, maxDuration=null, endTs=1458702548478, lookback=86400000, limit=1}"
      }
    },
    {
      "traceId": "5982fe77008310cc80f1da5e10147517",
      "name": "query",
      "id": "be2d01e33cc78d97",
      "parentId": "ebf33e1a81dc6f71",
      "timestamp": 1458702548786000,
      "duration": 13000,
      "localEndpoint": {
        "serviceName": "zipkin-query",
        "ipv4": "192.168.1.2",
        "port": 9411
      },
      "remoteEndpoint": {
        "serviceName": "spanstore-jdbc",
        "ipv4": "127.0.0.1",
        "port": 3306
      },
      "annotations": [
        {
          "timestamp": 1458702548786000,
          "value": "cs"
        },
        {
          "timestamp": 1458702548799000,
          "value": "cr"
        }
      ],
      "tags": {
        "jdbc.query": "select distinct `zipkin_spans`.`trace_id` from `zipkin_spans` join `zipkin_annotations` on (`zipkin_spans`.`trace_id` = `zipkin_annotations`.`trace_id` and `zipkin_spans`.`id` = `zipkin_annotations`.`span_id`) where (`zipkin_annotations`.`endpoint_service_name` = ? and `zipkin_spans`.`start_ts` between ? and ?) order by `zipkin_spans`.`start_ts` desc limit ?",
        "sa": "true"
      }
    },
    {
      "traceId": "5982fe77008310cc80f1da5e10147517",
      "name": "query",
      "id": "13038c5fee5a2f2e",
      "parentId": "ebf33e1a81dc6f71",
      "timestamp": 1458702548817000,
      "duration": 1000,
      "localEndpoint": {
        "serviceName": "zipkin-query",
        "ipv4": "192.168.1.2",
        "port": 9411
      },
      "remoteEndpoint": {
        "serviceName": "spanstore-jdbc",
        "ipv4": "127.0.0.1",
        "port": 3306
      },
      "annotations": [
        {
          "timestamp": 1458702548817000,
          "value": "cs"
        },
        {
          "timestamp": 1458702548818000,
          "value": "cr"
        }
      ],
      "tags": {
        "jdbc.query": "select `zipkin_spans`.`trace_id`, `zipkin_spans`.`id`, `zipkin_spans`.`name`, `zipkin_spans`.`parent_id`, `zipkin_spans`.`debug`, `zipkin_spans`.`start_ts`, `zipkin_spans`.`duration` from `zipkin_spans` where `zipkin_spans`.`trace_id` in (?)",
        "sa": "true"
      }
    },
    {
      "traceId": "5982fe77008310cc80f1da5e10147517",
      "name": "query",
      "id": "37ee55f3d3a94336",
      "parentId": "ebf33e1a81dc6f71",
      "timestamp": 1458702548827000,
      "duration": 2000,
      "localEndpoint": {
        "serviceName": "zipkin-query",
        "ipv4": "192.168.1.2",
        "port": 9411
      },
      "remoteEndpoint": {
        "serviceName": "spanstore-jdbc",
        "ipv4": "127.0.0.1",
        "port": 3306
      },
      "annotations": [
        {
          "timestamp": 1458702548827000,
          "value": "cs"
        },
        {
          "timestamp": 1458702548829000,
          "value": "cr"
        }
      ],
      "tags": {
        "jdbc.query": "select `zipkin_annotations`.`trace_id`, `zipkin_annotations`.`span_id`, `zipkin_annotations`.`a_key`, `zipkin_annotations`.`a_value`, `zipkin_annotations`.`a_type`, `zipkin_annotations`.`a_timestamp`, `zipkin_annotations`.`endpoint_ipv4`, `zipkin_annotations`.`endpoint_port`, `zipkin_annotations`.`endpoint_service_name` from `zipkin_annotations` where `zipkin_annotations`.`trace_id` in (?) order by `zipkin_annotations`.`a_timestamp` asc, `zipkin_annotations`.`a_key` asc",
        "sa": "true"
      }
    }
  ]  
```







