---
layout: post
title: "Python JWT"
comments: true
date: "2020-05-27 12:49:09.347000+00:00"
categories:  [programming]
tags:  [auth, flask, python, jwt]
---


```bash
pip3 install pyjwt
```

```python
from flask import Flask, request, jsonify, json, abort, redirect, url_for, render_template
from flask_cors import CORS, cross_origin
import flask
import os
import re
import jwt
import subprocess
import traceback
from functools import wraps

app = Flask(__name__, template_folder='template')
app.config["SECRET_KEY"] = "secret"
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


methods = ['GET', 'POST', 'PUT', 'OPTIONS']

def protected(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        req = request.json
        if "token" in req and token:
            token = req["token"]
            try:
                data = jwt.decode(token, app.config["SECRET_KEY"])
                print(data)
                return f(*args, **kwargs)
            except:
                traceback.print_exc()
                return jsonify({"message": "token is invalid or expired"}), 201
        else:
            return jsonify({"message": "protected auth failed"}), 201

    return decorated

@app.route('/login', methods=["POST"])
@cross_origin()
def login():
    req = request.json
    print(req)
    print("username", req["username"])
    print("password", req["password"])
    import datetime
    if req["username"] == "admin" and req["password"] == "password":
        exp = datetime.datetime.utcnow() + datetime.timedelta(minutes=2)
        token = jwt.encode({
                "username": req["username"],
                "exp": exp
        }, app.config["SECRET_KEY"])
        return jsonify({"message": "auth ok", "token": token.decode("UTF-8"), "exp": exp.isoformat()}), 200
    else:
        return jsonify({"message": "auth failed"}), 201


    #return jsonify({"message": "auth failed"}), 403


@app.route('/', methods=["POST"])
@cross_origin()
@protected
def main():
    print("path call")

    return jsonify({"message": "ok"}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7777, debug=True)
```

{% raw %}
<iframe id="myIframeIpynb0" style="border:none;" src="https://crashlaker.github.io/assets/posts_iframe/DT16sVapS-ipynb-0.html"></iframe>
<script>
setTimeout(() => {let myiframe = iFrameResize({ 
                    log: false, 
                    enablePublicMethods: true,
                }, '#myIframeIpynb0'); }, 1000)
</script>
{% endraw %}
    