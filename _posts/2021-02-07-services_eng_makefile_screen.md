---
layout: post
title: "Services eng Makefile screen"
comments: true
date: "2021-02-07 04:02:32.262000+00:00"
---


```


svc=crash-myad

stop:
	taskid=$$(screen -ls | awk '{print $$1}' | grep "$(svc)")
	if [ ! "$${taskid}" == "" ]; then
		screen -x $${taskid} -X quit
	fi
       
start:
	screen -dmS $(svc) bash -c "python3 app.py"
    
restart: stop start

.ONESHELL:
```