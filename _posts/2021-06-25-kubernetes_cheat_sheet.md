---
layout: post
title: "Kubernetes Cheat Sheet"
comments: true
date: "2021-06-25 03:33:24.858000+00:00"
---




## Local Host Folder Mount

https://kubernetes.io/docs/concepts/storage/volumes/#hostpath-fileorcreate-example


```
kubectl run lol --image=centos:7 --dry-run=client -o yaml > test.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: lol
  name: lol
  namespace: default
spec:
  containers:
  - image: centos:7
    name: lol
    resources: {}
    command: ["/usr/bin/bash"]
    args: ["-c", "sleep 1000000"]
    volumeMounts:
      - mountPath: /mnt/test
        name: test-volume
  volumes:
  - name: test-volume
    hostPath:
      path: /root/test
      type: Directory
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```


