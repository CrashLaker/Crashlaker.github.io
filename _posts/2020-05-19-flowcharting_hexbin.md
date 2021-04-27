---
layout: post
title: "Flowcharting HexBin"
comments: true
date: "2020-05-19 21:44:28.117000+00:00"
categories:  [visualization]
tags:  [grafana, flowcharting]
---




```python
@app.route('/', methods=methods)
@cross_origin()
def main():
    global color
    global tick
    ctemplate = """<mxCell id="{cellid}" value="" style="shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;rotation=90;fillColor={cellcolor};" vertex="1" parent="1">
          <mxGeometry x="{x}" y="{y}" width="20" height="20" as="geometry" />
        </mxCell>"""

    row = []
    cols = 20
    rows = 20
    ml = 50 #margin left
    mt = 50 #margin top
    counter = 10
    if tick <= 4:
        matrix = [[[40,30]]]
    elif tick <= 7:
        matrix = [[[20,30]]]
    elif tick < 13:
        matrix = [[[20,20], [20,20]]]
    else:
        matrix = [
                    [[20,20],[12,15]],
                    [[8,8],[6,3],[4,4]]
                ]
    #else:
    #    matrix = [[[40,30]]]
    #    tick = 0

    tick += 1
    for midx, mi in enumerate(matrix):
        for mcidx, (rows, cols) in enumerate(mi):
            sumleft = sum([a[1] for a in matrix[midx][:mcidx]])
            sumtop = sum([a[0][0] for a in matrix[:midx]])
            maxrows = max([a[0] for a in matrix[midx]])
            print(sumleft, maxrows, rows)
            print("sumtop", sumtop)
            ml = sumleft*20 + mcidx*30 #margin left
            mt = (sumtop*15 + midx*20) + (maxrows-rows-2)*15 #margin top
            for i in range(rows):
                for j in range(cols):
                    cellid = counter
                    counter+=1
                    x = ml + j*20 + 2
                    if i%2 == 1:
                        x += 10
                    y = mt + i*15
                    row.append(ctemplate.format(
                                    cellid=cellid,
                                    cellcolor=random.sample(color, 1).pop(),
                                    x=x,
                                    y=y
                                ))

    content = "\n".join(row)
    template = """
    <mxGraphModel dx="411" dy="240" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="PAGEWIDTH" pageHeight="PAGEHEIGHT" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        {CONTENT}
      </root>
    </mxGraphModel>
    """.format(
        PAGEWIDTH=100,
        PAGEHEIGHT=100,
        CONTENT=content
    )

    return template
```

![](/assets/img/wKX6SNMyy_flowcharting-hexbin2.gif)
