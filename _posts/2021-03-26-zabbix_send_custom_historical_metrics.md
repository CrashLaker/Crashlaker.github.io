---
layout: post
title: "Zabbix send custom historical metrics"
comments: true
date: "2021-03-26 03:33:41.766000+00:00"
---

https://www.zabbix.com/documentation/current/manpages/zabbix_sender


`zabbix-sender` + `zabbix trapper`

`zabbix_sender -z zabbix-server -p 10051 -s 'test' -k 'temp' -o 10`

or

https://www.zabbix.com/documentation/current/manual/appendix/items/trapper

https://github.com/adubkov/py-zabbix

```
from pyzabbix import ZabbixMetric, ZabbixSender

# Send metrics to zabbix trapper
packet = [
  ZabbixMetric('hostname1', 'test[cpu_usage]', 2),
  ZabbixMetric('hostname1', 'test[system_status]', "OK"),
  ZabbixMetric('hostname1', 'test[disk_io]', '0.1'),
  ZabbixMetric('hostname1', 'test[cpu_usage]', 20, 1411598020),
]

result = ZabbixSender(use_config=True).send(packet)
```
