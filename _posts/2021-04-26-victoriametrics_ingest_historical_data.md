---
layout: post
title: "VictoriaMetrics Ingest Historical Data"
comments: true
date: "2021-04-26 20:23:32.749000+00:00"
---



https://stackoverflow.com/questions/65751105/how-to-push-prometheus-metrics-directly-to-victoriametrics
https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/README.md#how-to-import-csv-data


![](/assets/img/jTnftTzXR_662de3faa8af583e5f8d2548eeef9625.png)

```python
import requests
import datetime

url = "http://localhost:8428/api/v1/import/csv"
now = int(datetime.datetime.now().timestamp())*1000)

params = {
	"format": ",".join([
		f"1:label:ServiceID",
		"2:metric:MSGs",
		"3:time:unix_ms",
	])
}

data = f"A,10,{now}"

rs = requests.post(url, params=params, data=data)

print(rs.text) # empty
```


