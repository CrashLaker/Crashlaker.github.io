---
layout: post
title: "Grafana SDG InspectIT Ocelote Demo"
comments: true
date: "2021-01-22 20:57:37.882000+00:00"
---

```bash
git clone https://github.com/inspectIT/inspectit-ocelot.git
cd inspectit-ocelot/inspectit-ocelot-demo
docker-compose -f docker-compose-influxdb-zipkin.yml up -d
```

Access grafana `http://<ip>:3001`

Login: admin
Password: demo

![](/assets/img/q_17rqFFU_inspectit-ocelote-demo-sdg.gif)


# Refs
* https://grafana.com/grafana/plugins/novatec-sdg-panel/installation
* https://inspectit.github.io/inspectit-ocelot/docs/getting-started/docker-examples