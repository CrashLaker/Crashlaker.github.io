---
layout: post
title: "Telemetry Study - Grafana Tempo Study"
comments: true
date: "2021-06-30 23:00:01.999000+00:00"
---


* https://dev.to/antongoncharov/distributed-logs-and-tracing-with-spring-apache-camel-opentelemetry-and-grafana-example-554e

## Infra

`docker-compose.yaml`

```yaml
version: '3'
services:
  tempo:
    image: grafana/tempo:latest
    volumes:
      - ./config.yaml:/config.yaml
    ports:
      - 9411:9411
      - 3100:3100
    command: ["-config.file", "/config.yaml"]
  grafana:
    image: grafana/grafana:8.0.4
    ports:
      - 3000:3000
  loki:
    image: grafana/loki:2.2.1
    ports:
      - "3101:3100"
    volumes:
      - ./loki-config.yaml:/etc/loki/local-config.yaml
    command: -config.file=/etc/loki/local-config.yaml
```

`config.yaml`

```yaml
server:
  http_listen_port: 3100

distributor:
  receivers:
    zipkin:

storage:
  trace:
    backend: local
    local:
      path: /tmp/tempo/blocks
```

## Grafana Tempo


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

### Python Example

#### Jaeger

```python
from opentelemetry import trace
from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

trace.set_tracer_provider(
    TracerProvider(
        resource=Resource.create({SERVICE_NAME: "my-helloworld-service"})
    )
)

jaeger_exporter = JaegerExporter(
    agent_host_name="localhost",
    agent_port=6831,
)

trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(jaeger_exporter)
)

tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("foo"):
    with tracer.start_as_current_span("bar"):
        with tracer.start_as_current_span("baz"):
            print("Hello world from OpenTelemetry Python!")
```

![](/assets/img/Pfi2w4LqP_cbb377394ff27c1bd88b45235d186164.png)

![](/assets/img/Pfi2w4LqP_48f102c3a69ae7286767c61865d164ba.png)

```json
{
    "name": "baz",
    "context": {
        "trace_id": "0x8342e0dad3853eb922985cbcd95e3362",
        "span_id": "0x4e93b924c39c4313",
        "trace_state": "[]"
    },
    "kind": "SpanKind.INTERNAL",
    "parent_id": "0x3f734c1712c2a36f",
    "start_time": "2021-07-07T23:57:22.572984Z",
    "end_time": "2021-07-07T23:57:22.573022Z",
    "status": {
        "status_code": "UNSET"
    },
    "attributes": {},
    "events": [],
    "links": [],
    "resource": {
        "telemetry.sdk.language": "python",
        "telemetry.sdk.name": "opentelemetry",
        "telemetry.sdk.version": "1.3.0",
        "service.name": "my-helloworld-service2"
    }
}
{
    "name": "bar",
    "context": {
        "trace_id": "0x8342e0dad3853eb922985cbcd95e3362",
        "span_id": "0x3f734c1712c2a36f",
        "trace_state": "[]"
    },
    "kind": "SpanKind.INTERNAL",
    "parent_id": "0xd302a32ab0c215b3",
    "start_time": "2021-07-07T23:57:22.572933Z",
    "end_time": "2021-07-07T23:57:22.573243Z",
    "status": {
        "status_code": "UNSET"
    },
    "attributes": {},
    "events": [],
    "links": [],
    "resource": {
        "telemetry.sdk.language": "python",
        "telemetry.sdk.name": "opentelemetry",
        "telemetry.sdk.version": "1.3.0",
        "service.name": "my-helloworld-service2"
    }
}
{
    "name": "foo2",
    "context": {
        "trace_id": "0x8342e0dad3853eb922985cbcd95e3362",
        "span_id": "0xd302a32ab0c215b3",
        "trace_state": "[]"
    },
    "kind": "SpanKind.INTERNAL",
    "parent_id": null,
    "start_time": "2021-07-07T23:57:22.572830Z",
    "end_time": "2021-07-07T23:57:22.573358Z",
    "status": {
        "status_code": "UNSET"
    },
    "attributes": {},
    "events": [],
    "links": [],
    "resource": {
        "telemetry.sdk.language": "python",
        "telemetry.sdk.name": "opentelemetry",
        "telemetry.sdk.version": "1.3.0",
        "service.name": "my-helloworld-service2"
    }
}
```


#### Zipkin

```python
from opentelemetry import trace
#from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.exporter.zipkin.json import ZipkinExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import (
    BatchSpanProcessor,
    ConsoleSpanExporter,
    SimpleSpanProcessor,
)

trace.set_tracer_provider(
    TracerProvider(
        resource=Resource.create({SERVICE_NAME: "my-helloworld-service"})
    )
)

zipkin_exporter = ZipkinExporter(                     
    # version=Protocol.V2                             
    # optional:                                       
    # endpoint="http://localhost:9411/api/v2/spans",  
    # local_node_ipv4="192.168.0.1",                  
    # local_node_ipv6="2001:db8::c001",               
    # local_node_port=31313,                          
    # max_tag_value_length=256                        
    # timeout=5 (in seconds)                          
    endpoint="http://grafana-tempo:9411/api/v2/spans",
)                                                     


trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(zipkin_exporter)
)
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(ConsoleSpanExporter)
    #SimpleSpanProcessor(ConsoleSpanExporter)
)

tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("foo"):
    with tracer.start_as_current_span("bar"):
        with tracer.start_as_current_span("baz"):
            print("Hello world from OpenTelemetry Python!")
```


![](/assets/img/Pfi2w4LqP_172c14e295a9e7d698159a66e3c36466.png)


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







