---
layout: post
title: "Grafana Loki + Tempo"
comments: true
date: "2021-07-07 04:18:56.405000+00:00"
---



https://grafana.com/blog/2020/11/09/trace-discovery-in-grafana-tempo-using-prometheus-exemplars-loki-2.0-queries-and-more/

![](/assets/img/TFqQC_6EZ_54d51a104eaaf81549e28d3a2461faea.png)

![](/assets/img/TFqQC_6EZ_09d3652c01a227a3ce1125528a5d3d24.png)


## Generate traces IDs


```python
import random                                     
                                                  
                                                  
def generate_span_id():                           
    return format(random.getrandbits(64), "016x") 
                                                  
def generate_trace_id():                          
    return format(random.getrandbits(128), "032x")
                                                  
for i in range(5):                                
    print(generate_trace_id())                    
    for y in range(3):                            
        print("\t", generate_span_id())           
```

```
720df654c44354080b87c12e010ce645
         341e26ebb4fae88a
         da684d213201068a
         227dda19ddca7f7f
4e415b55d33b0c3ef4b233fe35773012
         a715324aad511e10
         8ae6020daca64d96
         2b480db12be38626
c0853180db0098f11b8f566e987b0445
         eebd399178142f62
         c797d287f47e5c9e
         86ee0a2c3071d2ce
13d77af95b13453296b078841aaa7b28
         c8097b189448831b
         19a04532e82d4329
         681dff2b6a428b8c
2981b32401a0ce8e1cadabc3c0c75c58
         72d45590bf652d59
         78b152ba9ec15c41
         5f708de722d17cc3
```

https://github.com/open-telemetry/opentelemetry-python/blob/b3455cd1164f9c5f336cc26a52fb351cb422b0b2/opentelemetry-sdk/src/opentelemetry/sdk/trace/id_generator.py#L19

```python
class RandomIdGenerator(IdGenerator):
    """The default ID generator for TracerProvider which randomly generates all
    bits when generating IDs.
    """

    def generate_span_id(self) -> int:
        return random.getrandbits(64)

    def generate_trace_id(self) -> int:
        return random.getrandbits(128)
```

https://github.com/open-telemetry/opentelemetry-python/blob/d724573ef91abb880f0e1bd3c4431eb2a5ab0313/opentelemetry-api/src/opentelemetry/trace/span.py#L564

```python

def format_trace_id(trace_id: int) -> str:
    """Convenience trace ID formatting method
    Args:
        trace_id: Trace ID int
    Returns:
        The trace ID as 32-byte hexadecimal string
    """
    return format(trace_id, "032x")


def format_span_id(span_id: int) -> str:
    """Convenience span ID formatting method
    Args:
        span_id: Span ID int
    Returns:
        The span ID as 16-byte hexadecimal string
    """
    return format(span_id, "016x")
```


## Loki


```python
logdata = {
    "traceId": traceId,
    "status_code": 200,
    "path": "/"
}
for i in range(60):
    ds = datetime.datetime(2021,7,6,23,49) + datetime.timedelta(seconds=i)
    print(ds)
    timestamp = int(ds.timestamp()*1000000000)
    logdata = "path=\"/foo2\" status=201 a=2 b=5"
    logdata = "fizzbuzz"
    logdata = "test"
    logdata = f"path=\"/foo2\" status=204 a=2 b=5 c=3 d=9 traceID={traceId}"
    payload = {
        "streams": [
            {
                "stream": {
                    "__name__": "applog",
                    "foo": "bar3",
                    "job": "bar3",
                },
                "values": [
                    [str(timestamp), logdata],
                ]
            }
        ]
    }
    headers = {
        "Content-type": "application/json"
    }
    rs = requests.post(url_loki, json=payload)
    print(rs.text)
    #rs = requests.post(url_loki, headers=headers, data=json.dumps(payload))
```