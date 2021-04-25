---
layout: post
title: "Flask output pandas figure plot"
comments: true
date: "2020-05-13 01:59:09.167000+00:00"
categories:  [web]
tags:  [python, pandas, flask, render-image]
---





{% raw %}
<iframe id="myIframeIpynb0" style="border:none;" src="https://crashlaker.github.io/assets/posts_iframe/UMR_GNZ6m-ipynb-0.html"></iframe>
<script>
setTimeout(() => {let myiframe = iFrameResize({ 
                    log: false, 
                    enablePublicMethods: true,
                }, '#myIframeIpynb0'); }, 1000)
</script>
{% endraw %}
    

```python
import io
import random
from flask import Response
from flask import Flask, request, jsonify, json, abort, redirect, url_for, render_template
from flask_cors import CORS, cross_origin
import os
import re
import subprocess
import traceback
import matplotlib.pyplot as plt
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import pandas as pd
import numpy as np

app = Flask(__name__, template_folder='template')
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route('/plot.png')
def plot_png():
    #fig = create_figure()
    fig = return_plot()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')

def return_plot():
    # create some random data
    x = np.cumsum(np.random.rand(1000)-0.5)

    # plot it
    fig, ax = plt.subplots(1,1,figsize=(10,3))
    plt.plot(x, color='k', linewidth='2')
    plt.plot(len(x)-1, x[-1], color='r', marker='o')

    # remove all the axes
    for k,v in ax.spines.items():
        v.set_visible(False)
    ax.set_xticks([])
    ax.set_yticks([])

    #fig.set_tight_layout(True)
    fig.tight_layout()
    #fig.savefig("test.png", bbox_inches="tight")
    return fig

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000)

    #test
    #with app.test_client() as c:
    #    rs = c.get("/")
    #    print(rs.data)
```

![](/assets/img/UMR_GNZ6m_8f5285d1b09fdfa62ee640a70ed4645c.png)


https://stackoverflow.com/questions/50728328/python-how-to-show-matplotlib-in-flask
https://stackoverflow.com/questions/27543605/creating-sparklines-using-matplotlib-in-python