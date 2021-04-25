---
layout: post
title: "Matplotlib Horizon Plot"
comments: true
date: "2020-05-24 04:05:42.106000+00:00"
categories:  [datavis]
tags:  [python, matplotlib, horizon, cubism]
---




{% raw %}
<iframe id="myIframeIpynb0" style="border:none;" src="https://crashlaker.github.io/assets/posts_iframe/iVkUq-SAt-ipynb-0.html"></iframe>
<script>
setTimeout(() => {let myiframe = iFrameResize({ 
                    log: false, 
                    enablePublicMethods: true,
                }, '#myIframeIpynb0'); }, 1000)
</script>
{% endraw %}
    


```python
from flask import Response
from flask import Flask, request, jsonify, json, abort, redirect, url_for, render_template
from flask_cors import CORS, cross_origin
import matplotlib.pyplot as plt
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import pandas as pd
import numpy as np

@app.route('/plot.png')
def plot_png():
    #fig = create_figure()
    fig = horizon()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')

def horizon():
    plt.close('all')
    y = np.random.randint(100, size=30)
    p2i = lambda x: x/96
    fig = plt.figure()
    plt.gca().set_axis_off()
    plt.subplots_adjust(top=1,bottom=0,right=1,left=0,hspace=0,wspace=0)
    plt.margins(0,0)
    plt.gca().xaxis.set_major_locator(plt.NullLocator())
    plt.gca().yaxis.set_major_locator(plt.NullLocator())
    height = 20
    fontsize = height*.666
    fig.set_size_inches(p2i(160),p2i(height))
    maxval = 100
    layers = 4
    color = "#f5222d"
    for i in range(layers):
        plt.fill_between(range(len(y)), y-(maxval/layers)*i, alpha=0.2+(i/10)*1, color=color)
    plt.xlim(0,len(y)-1)
    plt.ylim(0,maxval/layers)
    #y[-1] = 4
    s = str(y[-1]) if y[-1] > 9 else f" {y[-1]}"
    s = y[-1]
    plt.text(len(y)-(1.5),4.5,s,bbox=dict(alpha=0), fontsize=fontsize, horizontalalignment='right')
    
    return fig

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=12000)
```

![](/assets/img/iVkUq-SAt_6f6afa0b2206f34a60539158026ebbe6.png)



horizon  
https://stackoverflow.com/questions/15167928/implementing-horizon-charts-in-matplotlib

no margins  
https://tex.stackexchange.com/questions/100190/how-can-i-remove-margins-when-integrating-matplotlib-plots-with-pgfplots


no axis, margins, ticks
https://stackoverflow.com/questions/11837979/removing-white-space-around-a-saved-image-in-matplotlib

```python
plt.gca().set_axis_off()
plt.subplots_adjust(top = 1, bottom = 0, right = 1, left = 0, 
            hspace = 0, wspace = 0)
plt.margins(0,0)
plt.gca().xaxis.set_major_locator(plt.NullLocator())
plt.gca().yaxis.set_major_locator(plt.NullLocator())
plt.savefig("filename.pdf", bbox_inches = 'tight',
    pad_inches = 0)
```