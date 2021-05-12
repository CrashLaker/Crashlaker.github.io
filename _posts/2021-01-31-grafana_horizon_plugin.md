---
layout: post
title: "Grafana Horizon Plugin"
comments: true
date: "2021-01-31 17:27:31.012000+00:00"
categories:  [grafana]
tags:  [horizon, cubism, plugin, grafana-plugin, grafana, small-multiples, data-vis]
---



![](https://files-ext.agunicat.co/favicon.png)

# v0.1.0

```
* Viz Engines
   * [x] Regular
   * [x] Horizon
   * [x] Discrete
   * [x] BarPlot
* Fix bugs:
    * [ ] Fix context draw is propagating in discrete vis when there's no data #4
    * [ ] Mouse value seek from position #10
    * [ ] Fill graph when box width is larger than 1pixel intervals #11
    * [x] Wide format... #7
    * [x] Barplot vis ignore negative scales when there are only negative or positive numbers #2
* Styles:
    * [x] Sketchy vis
*  Show:
    * [x] Labels
    * [x] Ruler Values
    * [x] Mirror/Offset View
* Set:
    * [x] bgColor
    * [x] Series Height
    * [x] Series Margin
    * [x] Bar Width
    * [x] Bar Margin Offset
    * [x] Thresholds
* Data:
    * [x] Sorting: [avg, percentile, max, min, last]
    * [x] Sort order
* Extra
    * [x] DummyData
    * [x] Anonymize
```

# Dev

```shell
# node > 12 < 13
nvm set default v12.22.1
npm i -g yarn
yarn install
yarn run watch
```


# Tasks

## Data sort

![](/assets/img/aELv5AgAT_fc4413606e6e31a028151b1a6d47977d.png)

![](/assets/img/aELv5AgAT_6957af146e89bae6a1a40159c7333e0d.png)


