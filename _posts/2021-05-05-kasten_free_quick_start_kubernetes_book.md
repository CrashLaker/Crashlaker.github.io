---
layout: post
title: "Kasten Free Quick Start Kubernetes Book"
comments: true
date: "2021-05-05 13:54:25.694000+00:00"
---


https://play.instruqt.com/kasten/tracks/kasten-quick-start-kubernetes-book

```
helm repo add kasten https://charts.kasten.io/
```

```
kubectl create namespace mysql
helm install mysql bitnami/mysql --namespace=mysql
```

```
watch -n 2 "kubectl -n mysql get pods"
```

```
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

kubectl exec -it --namespace=mysql $(kubectl --namespace=mysql get pods -o jsonpath='{.items[0].metadata.name}') \
  -- mysql -u root --password=$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE k10demo"
```

```
kubectl create namespace kasten-io; \
  helm install k10 kasten/k10 --namespace=kasten-io
```

```
watch -n 2 "kubectl -n kasten-io get pods"
```

```
kubectl annotate volumesnapshotclass csi-hostpath-snapclass k10.kasten.io/is-snapshot-class=true
```

```
cat > k10-nodeport-svc.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: gateway-nodeport
  namespace: kasten-io
spec:
  selector:
    service: gateway
  ports:
  - name: http
    port: 8000
    nodePort: 32000
  type: NodePort
EOF
```

```
kubectl apply -f k10-nodeport-svc.yaml
```

causing data loss

```
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
kubectl exec -it --namespace=mysql $(kubectl --namespace=mysql get pods -o jsonpath='{.items[0].metadata.name}') -- mysql -u root --password=$MYSQL_ROOT_PASSWORD -e "DROP DATABASE k10demo"
```


```
kubectl exec -it --namespace=mysql $(kubectl --namespace=mysql get pods -o jsonpath='{.items[0].metadata.name}') -- mysql -u root --password=$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES LIKE 'k10demo'"
```










