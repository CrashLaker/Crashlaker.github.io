---
layout: post
title: "Drawio CSV Demos"
comments: true
date: "2021-02-07 16:46:52.293000+00:00"
---


https://drawio-app.com/import-from-csv-to-drawio/

https://github.com/jgraph/drawio-diagrams/tree/master/examples/csv


## [Habit Tracker app AWS diagram](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/habit-tracker-app-aws.txt)
![](/assets/img/FRl8Bv-QP_habit-tracker.svg){:width="300px"}
<details>
<summary>
csv
</summary>
	
```
## Habit Tracker app AWS diagram
# label: %component%
# style: shape=%shape%;fillColor=%fill%;strokeColor=%stroke%;verticalLabelPosition=bottom;
# namespace: csvimport-
# connect: {"from":"refs", "to":"id", "invert":true, "style":"curved=0;endArrow=none;endFill=0;dashed=1;strokeColor=#6c8ebf;"}
# width: 80
# height: 80
# ignore: id,shape,fill,stroke,refs
# nodespacing: 40
# levelspacing: 40
# edgespacing: 40
# layout: horizontaltree
## CSV data starts below this line
id,component,fill,stroke,shape,refs
1,Habit Tracker HTML App,#ffe6cc,#d79b00,mxgraph.aws4.mobile,
2,UI Assets,#277116,#ffffff,mxgraph.aws4.s3,1
3,User Authentication,#C7131F,#ffffff,mxgraph.aws4.cognito,1
4,API Gateway,#5A30B5,#ffffff,mxgraph.aws4.api_gateway,1
5,AWS Lambda,#277116,none,mxgraph.aws4.lambda_function,4
6,Database,#3334B9,#ffffff,mxgraph.aws4.dynamodb,5
```
</details>


## [Supply chain tracking example](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/car-partial-supply-chain.txt)
![](/assets/img/FRl8Bv-QP_drawio-csv-example-supply-chain-tracking.svg)
<details>
<summary>
csv
</summary>
    
```
## Supply chain tracking example
# label: %name%
# stylename: shapeType
# styles: {"raw": "shape=parallelogram;fillColor=#f5f5f5;strokeColor=#666666;perimeter=parallelogramPerimeter;", \
#          "well": "shape=cylinder;fillColor=#f5f5f5;strokeColor=#666666;", \
#          "foundry": "shape=trapezoid;fillColor=#dae8fc;strokeColor=#6c8ebf;perimeter=trapezoidPerimeter;", \
#          "manufacturer":"shape=hexagon;fillColor=#d5e8d4;strokeColor=#82b366;perimeter=hexagonPerimeter;", \
#          "chemicals":"rounded=0;fillColor=#f8cecc;strokeColor=#b85450", \
#          "electronics":"rounded=1;fillColor=#fff2cc;strokeColor=#d6b656", \
#          "assembly":"shape=triangle;fillColor=#ffe6cc;strokeColor=#d79b00;perimeter=trianglePerimeter;", \
#          "component":"shape=ellipse;fillColor=#ffffff;strokeColor=#000000;perimeter=ellipsePerimeter;"}
# namespace: csvimport-
# connect: {"from":"supplier", "to":"id", "invert":true, "style":"curved=1;endArrow=blockThin;startArrow=none;strokeColor=#999999;endFill=1;"}
# width: auto
# height: auto
# padding: 40
# ignore: id,shapeType,supplier
# nodespacing: 40
# levelspacing: 40
# edgespacing: 40
# layout: horizontalflow
## CSV data starts below this line
id,name,supplier,shapeType
mb,Mine B,,raw
ma,Mine A,,raw
mc,Mine C,,raw
md,Mine D,,raw
w1,Well 1,,well
w2,Well 2,,well
w3,Well 3,,well
w4,Well 4,,well
fa,Foundry A,"mb,mc,ma",foundry
fb,Foundry B,"mc,md",foundry
fc,Foundry C,"ma,md",foundry
o1,Oil and Gas 1,w2,raw
o2,Oil and Gas 2,"w4,w3",raw
o3,Oil and Gas 3,w1,raw
man1,Manufacturer 1,fb,manufacturer
man2,Manufacturer 2,fc,manufacturer
man3,Manufacturer 3,fa,manufacturer
man4,Manufacturer 4,fc,manufacturer
man5,Manufacturer 5,ca,manufacturer
ca,Chemicals A,o3,chemicals
cb,Chemicals B,o1,chemicals
cc,Chemicals C,o2,chemicals
ea,Electronics A,cc,electronics
eb,Electronics B,cc,electronics
a1,Assembly 1,"3,4,5",assembly
a2,Assembly 2,2,assembly
a3,Assembly 3,"1,2,6,8,10,11",assembly
a4,Assembly 4,"9,12,13,7,15,14",assembly
a5,Assembly 5,16,assembly
1,gearbox housing,fb,component
2,gears,man3,component
3,turbine,man1,component
4,stator,man1,component
5,impellor,man1,component
6,bearings,man2,component
7,transmission fluid,cb,component
8,sealant,cc,component
9,transmission control unit,ea,component
10,gasket,man5,component
11,seals,man5,component
12,planetary gear train,a2,component
13,torque converter,a1,component
14,hydraulic controls,man4,component
15,gearbox,a3,component
16,transmission,a4,component
17,car,a5,component
```
</details>



## [Labels](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/labels.txt)
![](/assets/img/FRl8Bv-QP_drawio-csv-examples-labels.svg)
<details>
<summary>
csv
</summary>

```
## **********************************************************
## Example description
## **********************************************************
## This example shows you how to use and style labels. By default, there is one label type for all cells. You can have a custom number of parameters, but in this example, for label1 we used 3: name, position and email. Here, in the "labels" array below, we defined three separate label types, which we apply to each shape. The label type is defined in the last column of the CSV data.
## **********************************************************
## Configuration
## **********************************************************
# labels: {"label1" : "%name%<br><i style=\u0022color:gray;\u0022>%position%</i><br><a href=\u0022mailto:%email%\u0022>Email</a>",\
#          "label2" : "Type2<br>%name%", \
#          "label3" : "Type3"}
# labelname: labeltype
# style: whiteSpace=wrap;html=1;rounded=1;fillColor=#ffffff;strokeColor=#000000;
# namespace: csvimport-
# connect: {"from": "refs", "to": "id", "style": "curved=1;fontSize=11;"}
# width: auto
# height: auto
# padding: 5
# ignore: id,refs
# link: url
# nodespacing: 60
# levelspacing: 60
# edgespacing: 40
# layout: auto
## **********************************************************
## CSV Data
## **********************************************************
id,name,position,email,url,refs, labeltype
1,Evan Miller,CFO,me@example.com,https://www.draw.io,"2,3,4,5,6", label1
2,Edward Morrison,Brand Manager,me@example.com,https://www.draw.io,"", label1
3,Ron Donovan,System Admin,me@example.com,https://www.draw.io,"", label1
4,Tessa Valet,HR Director,me@example.com,https://www.draw.io,"", label1
5,Hanna Emerson,PR,me@example.com,https://www.draw.io,"", label2
6,Richard Newman,PR,me@example.com,https://www.draw.io,"", label3
```
</details>



## [Gitflow](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/gitflow.txt)

![](/assets/img/FRl8Bv-QP_drawio-csv-examples-gitflow.svg)
<details>
<summary>
csv
</summary>
    
```
## Gitflow 
# label: %version%
# namespace: csvimport-
# connect: {"from":"branched", "to":"entry", "style": "rounded=1;dashed=1;endArrow=none;endFill=0;startArrow=none;edgeStyle=elbowEdgeStyle;"}
#  
## Shapes and their styles
# stylename: branch
# styles: {"Master": "rhombus;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "Nightly": "ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#d5e8d4;strokeColor=#82b366;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "FeatureTeam2": "rounded=1;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#e1d5e7;strokeColor=#9673a6;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "FeatureTeam1": "rounded=1;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#e1d5e7;strokeColor=#9673a6;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "Dev": "shape=process;rounded=1;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#f5f5f5;strokeColor=#666666;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "Release": "shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "ReleaseFixes": "shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;",\
# "HotFix": "rhombus;whiteSpace=wrap;html=1;aspect=fixed;fontSize=10;fillColor=#f8cecc;strokeColor=#b85450;fontSize=12;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;"}
# ignore: entry,branch,feature,connected
# nodespacing: 20
# levelspacing: 30
# edgespacing: 20
# spacing: 10
# layout: horizontalflow
## CSV data starts below this line
entry,version,branch,feature,branched
1,1.0,Master,,2
2,1.0.1,Nightly,,"3,4,6"
3,A.1,FeatureTeam2,export,"8,12"
4,B.1,FeatureTeam1,import,"5,9"
5,B.1.1,Dev,,7
6,1.0.2,Nightly,,11
7,B.1.2,Dev,,9
8,A.1.1,Dev,,10
9,B.2,FeatureTeam1,import,11
10,A.1.2,Dev,,13
11,2.0.3,Nightly,,"12,15"
12,A.2,FeatureTeam1,export,"13,14"
13,A.2.1,Dev,,14
14,A.3,FeatureTeam1,export,15
15,2.0.4,Nightly,,"16,23"
16,RC1,Release,,"17,19"
17,RC1.1,ReleaseFixes,,18
18,RC1.2,ReleaseFixes,,19
19,RC2,Release,,"20,21"
20,RC2.1,ReleaseFixes,,21
21,RC3,Release,,22
22,2.0,Master,,"23,24"
23,2.0.1,Nightly,,"25,26,29"
24,HF1,HotFix,,28
25,C.1,FeatureTeam1,guides,
26,D.1,FeatureTeam2,sketch,27
27,D.1.1,Dev,,
28,2.1,Master,,29
29,2.1.2,Nightly,,
30,Master,Master,,"31,32"
31,HotFix,HotFix,,
32,Release,Release,,"33,34"
33,ReleaseFixes,ReleaseFixes,,
34,Nightly,Nightly,,"35,36"
35,FeatureTeam1,FeatureTeam1,guides,"37"
36,FeatureTeam2,FeatureTeam2,sketch,"37"
37,Dev,Dev,,
```
</details>




## [Network Topology](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/network-topology.txt)

![](/assets/img/FRl8Bv-QP_drawio-csv-examples-network-topology.svg)

<details>
<summary>
csv
</summary>

```
## Topology
# label: %host%
# namespace: csvimport-
# connect: {"from":"connected", "to":"entry", "style": "rounded=0;endArrow=none;endFill=0;startArrow=none;startFill=0;jumpStyle=sharp;"}
#  
## Shapes and their styles
# stylename: type
# styles: {"server": "fontColor=#232F3E;fillColor=#232F3E;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws4.traditional_server;perimeter=none;strokeColor=#232F3E;aspect=fixed;whiteSpace=wrap;",\
# "node": "fontColor=#232F3E;gradientColor=#505863;fillColor=#1E262E;strokeColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.general;",\
# "firewall": "fontColor=#232F3E;fillColor=#232F3E;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws4.generic_firewall;perimeter=none;strokeColor=#232F3E;aspect=fixed;whiteSpace=wrap;",\
# "database": "fontColor=#232F3E;fillColor=#232F3E;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;shape=mxgraph.aws4.generic_database;perimeter=none;strokeColor=#232F3E;labelPosition=center;horizontal=1;aspect=fixed;whiteSpace=wrap;"}
# ignore: entry,zone,type,connected
# nodespacing: 40
# levelspacing: 30
# edgespacing: 30
# layout: verticalflow
## CSV data starts below this line
entry,zone,type,host,connected
1,Internet,server,J2EE application server,3
2,Extranet frontend,node,Node (extranet),4
3,DMZ,firewall,Firewall 1,"5,6"
4,DMZ,firewall,Firewall 2,"7,8,12"
5,Warehouse,node,Node (Warehouse),9
6,ITS department,node,Node (ITS),"10,11,12"
7,PR department,node,Node (PR),12
8,HR department,node,Node (HR),11
9,Warehouse,server,Order system,
10,Data storage,server,Data services,
11,Data storage,database,Corporate database,
12,Extranet backend,server,Extranet server,
```
</details>


## [Habit Tracker UML](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/habit-tracker-app-use-case.txt)

![](/assets/img/FRl8Bv-QP_drawio-csv-examples-habit-tracker-uml.svg){:width="400px"}
<details>
<summary>
csv
</summary>

```
## Habit Tracker UML use case diagram
# label: %action%
# style: shape=%shape%;rounded=1;fillColor=%fill%;strokeColor=%stroke%;
# namespace: csvimport-
# connect: {"from":"refs", "to":"id", "style":"curved=0;endArrow=blockThin;endFill=1;"}
# connect: {"from":"includes", "to":"id", "label":"includes", "style": \
#             "curved=0;endArrow=blockThin;endFill=1;dashed=1;"}
# connect: {"from":"extends", "to":"id", "label":"extends", "style": \
#            "curved=0;endArrow=blockThin;endFill=1;dashed=1;"}
# width: auto
# height: auto
# padding: 40
# ignore: id,shape,fill,stroke,refs
# nodespacing: 40
# levelspacing: 40
# edgespacing: 40
# layout: horizontalflow
## CSV data starts below this line
id,action,fill,stroke,shape,includes,extends,refs
1,User,#dae8fc,#6c8ebf,umlActor,,,"3,4,5,6,7"
2,Coach,#dae8fc,#6c8ebf,umlActor,,,"10,6,7,12"
3,Add a habit,#dae8fc,#6c8ebf,ellipse,9,,
4,Delete a habit,#dae8fc,#6c8ebf,ellipse,9,,
5,Mark habit as done today,#dae8fc,#6c8ebf,ellipse,9,,
6,List habits,#dae8fc,#6c8ebf,ellipse,,,
7,View habit history,#dae8fc,#6c8ebf,ellipse,,8,
8,View one users habits,#dae8fc,#6c8ebf,ellipse,,12,
9,Update habit history,#dae8fc,#6c8ebf,ellipse,,,
10,Add a comment,#dae8fc,#6c8ebf,ellipse,9,5,
11,View single habit check-in,#dae8fc,#6c8ebf,ellipse,,7,
12,List all users,#dae8fc,#6c8ebf,ellipse,,,
```
</details>


## [Edges](https://github.com/jgraph/drawio-diagrams/blob/master/examples/csv/edges.txt)

![](/assets/img/FRl8Bv-QP_drawio-csv-examples-edges.svg)

<details>
<summary>
csv
</summary>

```
## **********************************************************
## Example description
## **********************************************************
## This example demonstrates the verious methods of using and styling connectors. The core of this example are the various "connect" configurations. All the connector styles are different, except the connection from Cell A to Cells F and Cell G. The connectors to Cells B, C, D and E show different connector styles. Note that when connecting to Cell E we didn't use the destination shape name, but its id instead, as defined in the "connect" configuration. The first line of the CSV data shows how you can connect to multiple shapes. The last entry in the CSV data shows that you can use self-references too. The diagram is a simple tree to improve the readability of this example, but you can use whatever diagram structure you need.
## **********************************************************
## Configuration
## **********************************************************
# label: %name%
# style: whiteSpace=wrap;html=1;rounded=1;fillColor=#ffffff;strokeColor=#000000;
# namespace: csvimport-
# connect: {"from": "relation1", "to": "name", "invert": true, "label": "manages", \
#          "style": "curved=1;endArrow=blockThin;endFill=1;fontSize=11;edgeStyle=orthogonalEdgeStyle;"}
# connect: {"from": "relation2", "to": "name", "invert": true, "label": "owns", \
#          "style": "curved=1;endArrow=ERmandOne;endFill=0;fontSize=11;dashed=1;"}
# connect: {"from": "relation3", "to": "name", "invert": true, "label": "waits for", \
#          "style": "endArrow=blockThin;endFill=1;fontSize=11;edgeStyle=orthogonalEdgeStyle;"}
# connect: {"from": "relation4", "to": "id", "invert": true, "label": "diff", \
#          "style": "endArrow=blockThin;endFill=1;fontSize=11;"}
# connect: {"from": "refs", "to": "id", "style": "curved=1;fontSize=11;"}
# width: auto
# height: auto
# padding: 5
# ignore: id,refs
# nodespacing: 60
# levelspacing: 120
# edgespacing: 40
# layout: auto
## **********************************************************
## CSV Data
## **********************************************************
id,name,relation1,relation2,relation3,relation4,refs
1,Cell A,,,,"","6,7"
2,Cell B,Cell A,,,"",""
3,Cell C,,Cell A,,"",""
4,Cell D,,,Cell A,"",""
5,Cell E,,,,"1",""
6,Cell F,,,,"",""
7,Cell G,Cell G,,,"",""
```
</details>

## [Org Chart](https://drawio-app.com/import-from-csv-to-drawio/)

![](/assets/img/FRl8Bv-QP_drawio-csv-examples-org-chart-2.svg){:width="300px"}
<details>
<summary>
csv
</summary>

```
##
## Example CSV import. Use ## for comments and # for configuration. Paste CSV below.
## The following names are reserved and should not be used (or ignored):
## id, tooltip, placeholder(s), link and label (see below)
##
#
## Node label with placeholders and HTML.
## Default is '%name_of_first_column%'.
#
# label: %name%<br><i style="color:gray;">%position%</i><br><a href="mailto:%email%">Email</a>
#
## Node style (placeholders are replaced once).
## Default is the current style for nodes.
#
# style: label;image=%image%;whiteSpace=wrap;html=1;rounded=1;fillColor=%fill%;strokeColor=%stroke%;
#
## Uses the given column name as the identity for cells (updates existing cells).
## Default is no identity (empty value or -).
#
# identity: -
#
## Connections between rows ("from": source colum, "to": target column).
## Label, style and invert are optional. Defaults are '', current style and false.
## In addition to label, an optional fromlabel and tolabel can be used to name the column
## that contains the text for the label in the edges source or target (invert ignored).
## The label is concatenated in the form fromlabel + label + tolabel if all are defined.
## The target column may contain a comma-separated list of values.
## Multiple connect entries are allowed.
#
# connect: {"from": "manager", "to": "name", "invert": true, "label": "manages", \
#          "style": "curved=1;endArrow=blockThin;endFill=1;fontSize=11;"}
# connect: {"from": "refs", "to": "id", "style": "curved=1;fontSize=11;"}
#
## Node x-coordinate. Possible value is a column name. Default is empty. Layouts will
## override this value.
#
# left: 
#
## Node y-coordinate. Possible value is a column name. Default is empty. Layouts will
## override this value.
#
# top: 
#
## Node width. Possible value is a number (in px), auto or an @ sign followed by a column
## name that contains the value for the width. Default is auto.
#
# width: auto
#
## Node height. Possible value is a number (in px), auto or an @ sign followed by a column
## name that contains the value for the height. Default is auto.
#
# height: auto
#
## Padding for autosize. Default is 0.
#
# padding: -12
#
## Comma-separated list of ignored columns for metadata. (These can be
## used for connections and styles but will not be added as metadata.)
#
# ignore: id,image,fill,stroke
#
## Column to be renamed to link attribute (used as link).
#
# link: url
#
## Spacing between nodes. Default is 40.
#
# nodespacing: 40
#
## Spacing between parallel edges. Default is 40.
#
# edgespacing: 40
#
## Name of layout. Possible values are auto, none, verticaltree, horizontaltree,
## verticalflow, horizontalflow, organic, circle. Default is auto.
#
# layout: auto
#
## ---- CSV below this line. First line are column names. ----
name,position,id,location,manager,email,fill,stroke,refs,url,image
Evan Miller,CFO,emi,Office 1,,me@example.com,#dae8fc,#6c8ebf,,https://www.draw.io,https://cdn3.iconfinder.com/data/icons/user-avatars-1/512/users-9-2-128.png
Edward Morrison,Brand Manager,emo,Office 2,Evan Miller,me@example.com,#d5e8d4,#82b366,,https://www.draw.io,https://cdn3.iconfinder.com/data/icons/user-avatars-1/512/users-10-3-128.png
Ron Donovan,System Admin,rdo,Office 3,Evan Miller,me@example.com,#d5e8d4,#82b366,"emo,tva",https://www.draw.io,https://cdn3.iconfinder.com/data/icons/user-avatars-1/512/users-2-128.png
Tessa Valet,HR Director,tva,Office 4,Evan Miller,me@example.com,#d5e8d4,#82b366,,https://www.draw.io,https://cdn3.iconfinder.com/data/icons/user-avatars-1/512/users-3-128.png
```
</details>






