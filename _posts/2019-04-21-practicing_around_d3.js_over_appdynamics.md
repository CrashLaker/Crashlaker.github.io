---
layout: post
title: "Practicing around D3.js over Appdynamics"
categories: [Medium]
tags: [datavis, appdynamics, monitoring, d3js, javascript]
comments: true
description: "Trying out novel visualization models to increase the insights over your infrastructure"
date: "2019-04-21"
---


[Originally posted on Medium](https://medium.com/@crashlaker/practicing-around-d3-js-over-appdynamics-2975a66bc364)

![](/assets/img/0ouLRKi1Z_1_qmGfx0pqmDLrWfXkHFsmfg.gif)
*GIF extracted from https://www.youtube.com/watch?v=nXXyWLft1zc*

> Disclaimer: Some contents written were based solely from my experience uppon using the Appdynamics dashboard. So suggestions and a more in-depth overview about appdynamic’s products are much appreciated.

## Appdynamics

Appdynamics like many other Application Performance Management (APM) tools helps you to trace, spot outliers and setup warnings when a certain service-level objectives (SLOs) such as response time or errors per minute, etc, happens by providing incredible visuals as well as the ability to drill down into the call stack methods to find the method at the exact moment an incident occured.

![](/assets/img/0ouLRKi1Z_0491100a14acec9427860f39557a7b53.png)
*Image taken from https://solucaoprimeitapmappdynamics.wordpress.com/tag/appdynamics/.*

## D3.js
D3.js is a javascript framework in which my first use case to it was to better organize basic lists and blocks with data loaded from APIs but its strongest feature and use case is that it allows you to bind arbitrary data to the Document Object Model (DOM) and then let’s you to pretty much render anything you want on the browser using HTML, SVGs, CANVAS and CSS.

![](/assets/img/0ouLRKi1Z_176d8cc48db73495066a0ccffd7e68dc.png)
**All D3.js examples here https://github.com/d3/d3/wiki/Gallery.**

## Appdynamics caveats
To state that this isn’t a “flaw” tothe Appdynamics product. It’s just that it didn’t suit my use case at first. Consider for example the first GIF of this article and the image below.

![](/assets/img/0ouLRKi1Z_4cf45e9792b8f47c2f367162250d4b85.png)
*Image taken from http://dailyrevshare.com/database-transaction-flow-chart/database-transaction-flow-chart-elegant-overview-of-application-monitoring-4-4-x-documentation/.*

By seeing those two pictures one can tell that Appdynamics perfectly describes each remote calls (called business transactions) and generates a component (represented by a visual circle) based on each application and features, such as the Database server and its model + database name or the Message Queue (MQ) server and its topics.
> So one cannot have a macro view of the infrastructure as a whole. What if I want to see which applications talk to one database? Which MQs depend on application X? Application Y is on top of which infrastructure (physical, vm, cloud)?

To answer the questions above one would have to manually go through all the applications and check if each one of them has a connection to database X for example. And when you have more than 50.. 100.. 1000.. applications.. you see where this is going. right?

![](/assets/img/0ouLRKi1Z_f023ca1a54d220f5353ab42d4b18d37c.png)
*Appdynamics menu taken from https://www.g2.com/products/appdynamics/details.*

So the image above shows the appdynamics menu taken from the browser where you can see the tabs Applications, Databases and Servers segregated.

The “Applications” tab indeed shows all the communications between them except for the databases and each objects representing the topics of each MQ server is shown instead of a unique node representing each MQ server.

## Appdynamics API
Luckly appdynamics has an extensive and [well documented API](https://docs.appdynamics.com/display/PRO45/API+Clients) where you can follow these few and easy steps to get access to its **REST API** or **RESTUI**. The latter not documented though with warning of unnoticed changes on further releases.

So you can just POST to `/controller/api/oauth/access_token` with your credentials to get your token:

```bash
curl -X POST -H "Content-Type: application/vnd.appd.cntrl+protobuf;v=1" "https://<controller address>/controller/api/oauth/access_token"

{
"access_token": "...",
"expires_in": 300
}
```

After this step you can just thought all Application’s Business Transactions and build a Directed Acyclic Graph (DAG) characterizing each Application’s dependencies. You can save this graph in structure you want but remember that if you save it in one of these two JSON formats you’re pretty much up to plug-n-play your new JSON to any **hierarchy** or **treemap** style of d3 example to see your data in action without needing to touch any javascript code… yet.

![](/assets/img/0ouLRKi1Z_acd55e262925d68e904120186139b81f.png)
*Layout 1 on the left. Layout 2 on the right.*

## Push data to D3.js
So I found one example that best suited my needs and.. boom! Right what I was looking for.

![](/assets/img/0ouLRKi1Z_8c46618d5ec2714aee5b1c41f96985c1.png)
*D3.js result from DAG graph generated from Appdynamics.*

Then after filtering some keywords that belonged to other applications and services it became more like this:

![](/assets/img/0ouLRKi1Z_93ba6e5dcd4bfce0f0f5f1e46b5da16d.png)

After hovering over one node:

![](/assets/img/0ouLRKi1Z_d6b45ee3a4d9cd90034098493d82933e.png)

Then moving to the hacking phase where you’re able to tweak some parts of the code to suit your needs.


![](/assets/img/0ouLRKi1Z_9968afa0152039eab80d1abad38dec4d.png)

Making it more organized and insightful when hovering:

![](/assets/img/0ouLRKi1Z_466a73e96137c8d1978b2bfbcea2d4e3.png)

You can pretty much do whatever you like by messing with the force. Like my attempt to copy appdynamics’ layout.

![](/assets/img/0ouLRKi1Z_bf935814343c2b7dda4235879fe74e82.png)

After hovering:

![](/assets/img/0ouLRKi1Z_1146442e7a85952edb3d689e8d9cb07c.png)

I know there’s plenty of tutorials about D3 and force graphs but I wanned to show you my use case and how you can first preview your data before having to mess or build a D3.js code from scratch which has a considerable learning curve like Paul Sweeney commented.
Thank you!

## References
* https://bl.ocks.org/agnjunio/fd86583e176ecd94d37f3d2de3a56814
* https://medium.com/@sxywu/understanding-the-force-ef1237017d5
* http://vallandingham.me/abusing_the_force.html





