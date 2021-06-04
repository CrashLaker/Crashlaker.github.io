---
layout: post
title: "Log Performance Monitoring Case Study"
comments: true
date: "2021-05-31 14:45:10.896000+00:00"
---

Summary


|                                 | ELK        | Splunk        | Loki    |
| ------------------------------- | ---------- | ------------- | ------- |
| Ingestion time elapsed          | ~ 10hours  | ~ 2h20minutes | ~6hours |
| Consumed indexed disk size      | ~ 107Gb    | ~ 40Gb        | ~9Gb    |
| Query 1 month (12/12h interval) | 4mins      | 1h30min       | 27mins  |
| Query 1 month (30s interval)    | ![][cross] | ![][cross]    | 27mins  |
| Query 1 day (12/12interval)     | few secs   | 4mins         | 1min    |
| Query 1 day (30s interval)      | ![][cross] | ![][cross]    | 1min    |

![](/assets/img/LbamznIiO_b050de275d2919852449bf73c2ca27bd.png)

[cross]: https://cdn3.iconfinder.com/data/icons/fatcow/16/cross.png



## Loki

![](/assets/img/LbamznIiO_63ec195223cee50b72a486c1e87a0d10.png)

start 57gb
end 66gb

![](/assets/img/LbamznIiO_cee8e3f867722526ec822eea851db896.png)


interval 30s

![](/assets/img/LbamznIiO_192b6451ca594fc218d0c8ce44e66b47.png)

~6hours

![](/assets/img/LbamznIiO_9235428d0b759f114479ff21566304a8.png)

![](/assets/img/LbamznIiO_84d52ecaa35f7ef631e958aaa58a45aa.png)

---

12h interval

![](/assets/img/LbamznIiO_4b8c6c92b465420ed1d0abb0711007ea.png)

![](/assets/img/LbamznIiO_153bfc975d44eb643ca5fad86d0b48e3.png)




## SPLUNK
![](/assets/img/LbamznIiO_0ebaea3b012d2509c71d3fc8bb74ad69.png)

start 61gb 
end 100gb

![](/assets/img/LbamznIiO_d5cf94b64b79600b3b7c49e59f4936c7.png)


![](/assets/img/LbamznIiO_6d58d6865bb55a44fb7b1475b5f3ba5c.png)

![](/assets/img/LbamznIiO_0f9f3c9d2708b816d4a3a13bf786386e.png)

![](/assets/img/LbamznIiO_f23cf43c25e06356b89f04938f958715.png)

![](/assets/img/LbamznIiO_a1f6283dd705ed0582dcb68a5c79e4cd.png)

may 10th

![](/assets/img/LbamznIiO_5415d6b2f3c5752149d12dc1777c984a.png)

![](/assets/img/LbamznIiO_5035544ead7964219a1d7bb7a37c2af6.png)




## ELK

![](/assets/img/LbamznIiO_3f70570aa65e7cf0e1018e23bc6a9d18.png)

154gb 250gb

![](/assets/img/LbamznIiO_46021cbc59a81abb6980a4df109a3ca1.png)

![](/assets/img/LbamznIiO_fc121f67590e2e09c49422e2b05affe2.png)

![](/assets/img/LbamznIiO_9868ca95413032fd6bd0abac47d1949b.png)

12h/12h interval

![](/assets/img/LbamznIiO_d80d3fd67ed44e4109b2cfdaf1a8ba82.png)

4mins

![](/assets/img/LbamznIiO_ab61f99df37eb2915396b92378543a87.png)

may10th




# From CMD


row.append(f"{{ \"time\":\"{datefmt}\", \"path\":\"{path}\", \"status\":\"{status_code}\" }}")

# Code

```
import pandas as pd
import math
import os
import random
import datetime
import numpy as np
import matplotlib.pyplot as plt

random.seed(8)

status_codes = [200, 304, 500, 408, 404, 302]
status_codes += [s for s in status_codes for i in range(random.randint(10,50))]
# dummy_weight
paths = [f"page{i}" for i in range(0, 300)]
paths += [p for p in random.sample(paths, 20) for i in range(random.randint(10,50))]

series = []
variance = 0
start = datetime.datetime(2021,5,1)
for i in range(310):
    variance += (random.random() - 0.5)/10
    val = math.cos(i/10) + variance
    series.append(abs(val) * random.randint(8,40)*1000)
df = pd.DataFrame({"x": [start+datetime.timedelta(minutes=1*i) for i in range(len(series))], "y": series})
df.set_index('x').plot(figsize=(18,6))


# 31days * 24hours * 60minutes = 44640
arr = [float('nan') for i in range(44640)]
for idx,v in enumerate(series):
    arr[idx*144] = v
ts_start = datetime.datetime(2021,5,1).timestamp()
x = [datetime.datetime.fromtimestamp(ts_start+60*i) for i in range(len(arr))]
df = pd.DataFrame({"x": x, "y": arr})
df['y'] = df['y'].interpolate(method='linear')
df['y'] = df['y'].astype(int)
df.set_index('x').plot(figsize=(18,6))



logdir = "./logdir"
if not os.path.exists(logdir):
    os.mkdir(logdir)
    

%%time
for idx,v in enumerate(df['y'].values):
    row = []
    dstart = datetime.datetime(2021,5,1) + datetime.timedelta(minutes=idx)
    dstart = dstart
    filename = logdir + "/" + dstart.strftime("%Y-%m-%d.log")
    dstart = float(dstart.timestamp()*1000)
    t = np.linspace(0, 59, v) * 1000
    for i in t:
        ts = int(dstart+i)
        ds = datetime.datetime.fromtimestamp(ts/1000.0)
        datefmt = ds.strftime("[%d/%b/%Y:%H:%M:%S.%f")[:-3] + " -0300]"
        status_code = random.choice(status_codes)
        path = random.choice(paths)
        row.append(f"{{ \"time\":\"{datefmt}\", \"path\":\"{path}\", \"status\":\"{status_code}\" }}")
    if os.path.exists(filename):
        with open(filename, "a+") as f:
            f.write("\n")
    with open(filename, "a+") as f:
        f.write("\n".join(row))
  

CPU times: user 1h 16min 53s, sys: 1min 16s, total: 1h 18min 10s
Wall time: 3h 28min 21s
```

```
{ "time":"[01/May/2021:00:00:00.000 -0300]", "path":"page153", "status":"302" }
{ "time":"[01/May/2021:00:00:00.001 -0300]", "path":"page112", "status":"304" }
{ "time":"[01/May/2021:00:00:00.003 -0300]", "path":"page6", "status":"408" }
{ "time":"[01/May/2021:00:00:00.005 -0300]", "path":"page54", "status":"404" }
{ "time":"[01/May/2021:00:00:00.007 -0300]", "path":"page113", "status":"304" }
{ "time":"[01/May/2021:00:00:00.009 -0300]", "path":"page81", "status":"200" }
{ "time":"[01/May/2021:00:00:00.011 -0300]", "path":"page75", "status":"302" }
{ "time":"[01/May/2021:00:00:00.013 -0300]", "path":"page147", "status":"408" }
{ "time":"[01/May/2021:00:00:00.015 -0300]", "path":"page198", "status":"404" }
```
```
2.9G    logdir/2021-05-01.log
1.1G    logdir/2021-05-02.log
2.3G    logdir/2021-05-03.log
3.1G    logdir/2021-05-04.log
1.4G    logdir/2021-05-05.log
1.5G    logdir/2021-05-06.log
2.7G    logdir/2021-05-07.log
895M    logdir/2021-05-08.log
2.2G    logdir/2021-05-09.log
2.8G    logdir/2021-05-10.log
870M    logdir/2021-05-11.log
1.7G    logdir/2021-05-12.log
3.2G    logdir/2021-05-13.log
2.4G    logdir/2021-05-14.log
818M    logdir/2021-05-15.log
3.6G    logdir/2021-05-16.log
2.2G    logdir/2021-05-17.log
957M    logdir/2021-05-18.log
1.8G    logdir/2021-05-19.log
2.4G    logdir/2021-05-20.log
963M    logdir/2021-05-21.log
2.7G    logdir/2021-05-22.log
2.6G    logdir/2021-05-23.log
664M    logdir/2021-05-24.log
2.8G    logdir/2021-05-25.log
3.8G    logdir/2021-05-26.log
1.2G    logdir/2021-05-27.log
2.7G    logdir/2021-05-28.log
3.3G    logdir/2021-05-29.log
1.4G    logdir/2021-05-30.log
2.0G    logdir/2021-05-31.log
```

# ELK

## Logstash

### install
```shell
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF > /etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum -y install logstash
echo "export PATH=\"/usr/share/logstash/bin/:$PATH\"" >> /root/.bashrc
export PATH="/usr/share/logstash/bin/:$PATH"
```

### config

`logstash.conf`

```
input {
    file {
        path => "/root/wkdir/logs/*.log"
        start_position => "beginning"
        #codec => multiline {
        #    pattern => '.*128=.*'
        #    negate => false
        #    what => previous
        #}
        sincedb_path => "/dev/null"        
    }
}


# https://stackoverflow.com/questions/27443392/how-can-i-have-logstash-drop-all-events-that-do-not-match-a-group-of-regular-exp
filter {
    grok {
        add_tag => [ "valid" ]
        match => {
            "message" => [
                ".*?"time":"(?P<time>[^"]+)".*?path":"(?<path>[^"]+)".*"status":"(?<status>[^"]+)""
            ]
        }
    }
    # https://discuss.elastic.co/t/what-is-the-date-format-to-be-used-with-logstash-to-match-9-digits-millisecond/107032 
    # https://discuss.elastic.co/t/how-to-replace-timestamp-with-logtime/118949/2
    # 20210521-23:47:00.333333333
    date {
        match => ["time", "yyyyMMdd-HH:mm:ss.SSS Z"]
        target => "@timestamp"
        remove_field => ["time"]
    }

    if "_grokparsefailure" in [tags] {
        drop {}
    }

    if "valid" not in [tags] {            
        drop { }
    }

    if "128=" not in [message] {            
        drop { }
    }

    mutate {
        remove_tag => [ "valid" ]
        #remove_field => [ "message" ]
    }
}

output {
    elasticsearch {
        hosts => ["localhost:9200"]
        index => "fix"
    }
    #stdout {
    #    codec => json_lines
    #}
}
```




# SPLUNK


```shell
yum -y install http://vdi-loitt-0007/dummy_upload/splunk-8.2.0-e053ef3c985f-linux-2.6-x86_64.rpm
```

```
.*? IN (?P<_time>[^ ]+).*?49=(?P<client>[A-Z0-9]+).*?128=(?P<session>[A-Z0-9]+).*
```

```
.*?"time":"\[(?P<time>[^\]]+)\]".*?path":"(?<path>[^"]+)".*"status":"(?<status>[^"]+)"
```

`/opt/splunk/bin/splunk start`

```
sourcetype=nginx | timechart useother=f limit=1000 span=1h count by status
```

```
sourcetype=nginx | timechart useother=f limit=1000 span=1h count by path
```

# Loki


**docker-compose.yaml**
```yaml
version: "3"

networks:
  loki:

services:
  loki:
    image: grafana/loki:2.2.0
    ports:
      - "3100:3100"
    volumes:
      - ./loki-config.yaml:/etc/loki/local-config.yaml
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - loki

  promtail:
    image: grafana/promtail:2.2.0
    volumes:
      - ./logs:/logs
      - ./promtail-config.yaml:/etc/promtail/config.yaml
    command: -config.file=/etc/promtail/config.yaml
    networks:
      - loki

        #  grafana:
        #    image: grafana/grafana:latest
        #    ports:
        #      - "3000:3000"
        #    networks:
        #      - loki

```

**loki-config.yaml**
```yaml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  http_server_read_timeout: 20m
  http_server_write_timeout: 20m

ingester:
  wal:
    enabled: true
    dir: /tmp/wal
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 1h       # Any chunk not receiving new logs in this time will be flushed
  max_chunk_age: 1h           # All chunks will be flushed when they hit this age, default is 1h
  chunk_target_size: 1048576  # Loki will attempt to build chunks up to 1.5MB, flushing first if chunk_idle_period or max_chunk_age is reached first
  chunk_retain_period: 30s    # Must be greater than index read cache TTL if using an index cache (Default index read cache TTL is 5m)
  max_transfer_retries: 0     # Chunk transfers disabled

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /tmp/loki/boltdb-shipper-active
    cache_location: /tmp/loki/boltdb-shipper-cache
    cache_ttl: 24h         # Can be increased for faster performance over longer query periods, uses more disk space
    shared_store: filesystem
  filesystem:
    directory: /tmp/loki/chunks

querier:
  query_timeout: 20m
  engine:
    timeout: 20m

compactor:
  working_directory: /tmp/loki/boltdb-shipper-compactor
  shared_store: filesystem

limits_config:
  reject_old_samples: false
  ingestion_rate_mb: 16
  ingestion_burst_size_mb: 32
  max_streams_per_user: 100000
  #reject_old_samples_max_age: 168h

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: false
  retention_period: 0s

ruler:
  storage:
    type: local
    local:
      directory: /tmp/loki/rules
  rule_path: /tmp/loki/rules-temp
  alertmanager_url: http://localhost:9093
  ring:
    kvstore:
      store: inmemory
  enable_api: true
  search_pending_for: 20m
```

**promtail-config.yaml**
```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
- job_name: receive_vdi7_nginx
  pipeline_stages:
  - match:
      selector: '{job="nginx"}'
      stages:
        - json:
            expressions:
              time:
              path:
              status:

        - labels:
            path:
            status:
  
        - timestamp:
            #{ "time":"[01/May/2021:23:59:58.979 -0300]", "path":"page260", "status":"200" }
            source: time
            format: "[02/Jan/2006:15:04:05.000 -0700]"
                    
  static_configs:
  - targets:
      - nginx 
    labels:
      job: nginx
      __path__: /logs/*.log
```


```
loki_1      | level=info ts=2021-06-01T21:10:03.807789807Z caller=metrics.go:91 org_id=fake traceID=7ebc8a4c75fb2651 latency=slow query="sum by (status) (\r\n    count_over_time({job=\"nginx\"}\r\n    [30s]\r\n    )\r\n)\r\n" query_type=metric range_type=range length=24h0m0s step=30s duration=51.944914194s status=200 limit=1944 returned_lines=0 throughput=59MB total_bytes=3.1GB
loki_1      | level=info ts=2021-06-01T21:10:05.780238114Z caller=metrics.go:91 org_id=fake traceID=38dae5f961aa625 latency=slow query="sum by (path) (\r\n    count_over_time({job=\"nginx\"}\r\n    [30s]\r\n    )\r\n)\r\n" query_type=metric range_type=range length=24h0m0s step=30s duration=53.915508495s status=200 limit=1944 returned_lines=0 throughput=57MB total_bytes=3.1GB
```



```
loki_1      | level=info ts=2021-06-01T22:48:40.488800401Z caller=metrics.go:91 org_id=fake traceID=143d4840af9b9155 latency=slow query="sum by (status) (\r\n    count_over_time({job=\"nginx\"}\r\n    [20m]\r\n    )\r\n)\r\n" query_type=metric range_type=range length=744h0m0s step=20m0s duration=27m20.345708133s status=200 limit=1944 returned_lines=0 throughput=43MB total_bytes=70GB
loki_1      | level=info ts=2021-06-01T22:48:42.936430307Z caller=metrics.go:91 org_id=fake traceID=fa4f6dfe2a0a79 latency=slow query="sum by (path) (\r\n    count_over_time({job=\"nginx\"}\r\n    [20m]\r\n    )\r\n)\r\n" query_type=metric range_type=range length=744h0m0s step=20m0s duration=27m22.792997646s status=200 limit=1944 returned_lines=0 throughput=43MB total_bytes=70GB
```


12h interval
```
loki_1      | level=info ts=2021-06-01T23:21:19.19471531Z caller=metrics.go:91 org_id=fake traceID=240897a1cfbb620 latency=slow query="sum by (status) (\r\n    count_over_time({job=\"nginx\"}\r\n    [12h]\r\n    )\r\n)\r\n" query_type=metric range_type=range length=744h0m0s step=20m0s duration=24m56.535993527s status=200 limit=1944 returned_lines=0 throughput=47MB total_bytes=70GB
loki_1      | level=info ts=2021-06-01T23:21:22.295464997Z caller=metrics.go:91 org_id=fake traceID=6cbc2a302d7811b6 latency=slow query="sum by (path) (\r\n    count_over_time({job=\"nginx\"}\r\n    [12h]\r\n    )\r\n)\r\n" query_type=metric range_type=range length=744h0m0s step=20m0s duration=24m59.633471403s status=200 limit=1944 returned_lines=0 throughput=47MB total_bytes=70GB
```





