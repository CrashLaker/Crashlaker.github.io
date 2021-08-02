---
layout: post
title: "Grafana SimpleJson Flask Template"
comments: true
date: "2021-02-06 15:47:42.281000+00:00"
tags:  tags, // Tags for the annotation. (optional)                   
---


```python
from flask import Flask, request, jsonify
from flask_cors import CORS
import dateutil.parser
import datetime

app = Flask(__name__)
cors = CORS(app)

@app.route('/', methods=['GET', 'POST'])
def main():
    return "você acessou o /"

@app.route('/search', methods=['GET', 'POST'])
def r_search():

    return "você acessou o /search"

@app.route('/query', methods=['GET', 'POST'])
def r_query():

    req = request.json

    dfrom = dateutil.parser.parse(req["range"]["from"])
    dto = dateutil.parser.parse(req["range"]["to"])
    from_ms = dfrom.timestamp()*1000
    to_ms = dto.timestamp()*1000
    
    target = req['targets'][0]['target']

    response = [
        {
            "target": req["targets"][0]["target"],
            "datapoints": [
                [100, from_ms], # valor 100 no inicio da range
                [200, to_ms], # valor 200 no fim da range
            ]
        }
    ]

    return jsonify(response)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081)
```

## Tag Keys Values

![](/assets/img/5Vh3D2CEQ_467c83126762d240acb85caf6416e217.png)

![](/assets/img/5Vh3D2CEQ_85592b20de03cd532cc6d81eba5320d2.png)

`adhocFilters` keys will be sent in every request

![](/assets/img/5Vh3D2CEQ_37a741fa8122efcfaf97f28669a1700b.png)


```python
@app.route('/tag-keys', methods=['GET', 'POST'])  
def r_tag_keys():                                 
    ret = [                                       
        {"type":"string","text":"City"},          
        {"type":"string","text":"Country"}        
    ]                                             
                                                  
    return jsonify(ret)                           
                                                  
@app.route('/tag-values', methods=['GET', 'POST'])
def r_tag_values():                               
                                                  
    req = request.json                            
    #{'key': 'City'}                              
    print("tag vlaues req", req)                  
    key = req.get("key")                          
    ret = []                                      
    if key == "City":                             
        ret = [                                   
            {"type":"string","text":"SP"},        
            {"type":"string","text":"RJ"}         
        ]                                         
    elif key == "Country":                        
        ret = [                                   
            {"type":"string","text":"Brazil"},    
            {"type":"string","text":"China"}      
        ]                                         
                                                  
    return jsonify(ret)                           
```


## Annotations

![](/assets/img/5Vh3D2CEQ_a5f44e6aef8d9eb9706220d38f1d75f8.png)


![](/assets/img/5Vh3D2CEQ_99a8f525ab0b4e55dd4148eed560ce05.png)


```python
@app.route('/annotations', methods=['GET', 'POST'])                          
def r_annotations():                                                         
    print("annotations")                                                     
    req = request.json                                                       
    pprint(req)                                                              
    """                                                                      
    {'annotation': {'datasource': 'dummy',                                   
                'enable': True,                                              
                'iconColor': 'rgba(255, 96, 96, 1)',                         
                'name': 'test',                                              
                'query': 'lalal'},                                           
     'range': {'from': '2021-08-01T16:22:08.553Z',                           
               'raw': {'from': 'now-6h', 'to': 'now'},                       
               'to': '2021-08-01T22:22:08.553Z'},                            
     'rangeRaw': {'from': 'now-6h', 'to': 'now'}}                            
    ### reponse                                                              
    [                                                                        
      {                                                                      
        annotation: annotation, // The original annotation sent from Grafana.
        time: time, // Time since UNIX Epoch in milliseconds. (required)     
title: "Grafana SimpleJson Flask Template"
        text: text // Text for the annotation. (optional)                    
      }                                                                      
    ]                                                                        
    """                                                                      
                                                                             
    ret = [                                                                  
      {                                                                      
        "annotation": "started blabla",                                      
        "time":       datetime.datetime(2021,8,1,16).timestamp()*1000,       
        "title":      "Started Title",                                       
        "tags":       ["tag0", "tag1"],                                      
        "text":       "text field",                                          
      }                                                                      
    ]                                                                        
                                                                             
    return jsonify(ret)                                                      
```











