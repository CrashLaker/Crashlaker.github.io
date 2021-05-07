---
layout: post
title: "AppDynamics to Grafana SDG"
comments: true
date: "2021-05-07 03:54:23.551000+00:00"
---



anonymize

```python
import uuid
import random

opts = ['http', 'java', 'web', 'database', 'balancer', 'message'] + ['']*4
names = {}
def pnames(name):
    return name
    if name in names:
        return names[name]
    iid = uuid.uuid4().hex[:8]
    while iid in names:
        iid = uuid.uuid4().hex[:8]
    names[name] = iid+random.choice(opts)
    return iid

apps = {
    pnames(i['name']):i['id']
    for i in appd_metrics.list_apps()
}
```


```python
@app.route('/query', methods=['GET', 'POST'])
def r_query():
    
    req = request.json
    
    target = req['targets'][0]['target']
    target = target.replace('app=', '')
    from_ms = int(dateutil.parser.parse(req['range']['from '].timestamp()*1000))*1000
    to_ms = int(dateutil.parser.parse(req['range']['from '].timestamp()*1000))*1000
    
    graph = get_app_graph(appid, from_ms, to_ms)
    
    rows = []
    for d in graph:
        """
        'stats': {'averageResponseTime': {'metricValue': 1840, 'metricId': 4234234},
        'callsPerMinute': {'metricValue': 30, 'metricId' : 111},
        'errorsPerMinute': {'metricValue': 30, 'metricId' : 111},
        'numberOfErrors': {'metricValue': 30, 'metricId' : 111},
        'numberOfCalls': {'metricValue': 30, 'metricId' : 111},
        'transactionStats': None,
        'asyncTransactionStats': None},
        """
        
        if not d.get('target'): continue
        origin_name = pnames(d['name'])
        target_name = pnames(d['target']['name'])
        
        resptime = d['stats']['averageResponseTime']['metricValue']
        reqrate = d['stats']['callsPerMinute']['metricValue']
        errrate = d['stats']['errorsPerMinute']['metricValue']
        req_rate_out = d['stats']['numberOfCalls']['metricValue']
        err_rate_out = d['stats']['numberOfErrors']['metricValue']
        
        rows.append({
            'origin_app': origin_name,
            'app': target_name,
            'response-time': resptime,
            'request-rate': reqrate,
            'error-rate': errrate,
            'request-rate-out': req_rate_out,
            'error-rate-out': err_rate_out
        })
    if 1:
        cols = [
            {'text': 'origin_app', 'type': 'string'},
            {'text': 'app', 'type': 'string'},
            {'text': 'response-time', 'type': 'number'},
            {'text': 'request-rate', 'type': 'number'},
            {'text': 'error-rate', 'type': 'number'},
            {'text': 'request-rate-out', 'type': 'number'},
            {'text': 'error-rate-out', 'type': 'number'},
        ]
        reponse = [
            {
                'columns': cols,
                'rows': [
                    [r[c['text']] for c in cols]
                    for r in rows
                ],
                'type': 'table'
            }
        ]
```


get_app_graph

```python
def get_app_graph(app_id, from_ms, to_ms):
    timerange = f"Custom_Time_Range.BETWEEN_TIMES.{to_ms}.{from_ms}.10080"
    graph = appd_metrics.get_api("http://appdynamics/controller/restui/applicationFlowMapUiService/application/{app_id}?time-range={timerange}&mapId=-1&baselineId=-1&forceFetch=true")
    
    mygraph = {}
    for d in graph['nodes']:
        mygraph[d['id']] = d
    edges_summary = {}
    for d in graph['edges']:
        sourceNode = d['sourceNode']
        targetNode = d['targetNode']
        if not sourceNode in edges_summary:
            edges_summary[sourceNode] = {}
        edges_summary[sourceNode][targetNode] = mygraph.get(targetNode, {}).get('name', '')
    row = []
    for nodeid in mygraph:
        if nodeid in edges_summary:
            for targetid in edges_summary[nodeid]:
                row.append({
                    **mygraph[nodeid],
                    'target': mygraph[targetid]
                })
        else:
            row.append({
                **mygraph[nodeid]
            })
    return row
```











