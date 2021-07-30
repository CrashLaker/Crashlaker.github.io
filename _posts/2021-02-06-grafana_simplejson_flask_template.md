---
layout: post
title: "Grafana SimpleJson Flask Template"
comments: true
date: "2021-02-06 15:47:42.281000+00:00"
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