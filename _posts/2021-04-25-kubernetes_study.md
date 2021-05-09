---
layout: post
title: "Kubernetes Study"
comments: true
date: "2021-04-25 22:19:29.465000+00:00"
---


* https://www.udemy.com/course/learn-kubernetes/
* https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/
	* Certified Kubernetes Administrator:
		*  https://www.cncf.io/certification/cka/
	* Exam Curriculum (Topics):
		*  https://github.com/cncf/curriculum
	* Candidate Handbook:
		*  https://www.cncf.io/certification/candidate-handbook
	* Exam Tips:
		*  http://training.linuxfoundation.org/go//Important-Tips-CKA-CKAD
* Useful:
    * https://medium.com/dev-genius/kubernetes-for-local-development-a6ac19f1d1b2
        * docker desktop
        * minikube
        * kind
        * k3s


![](/assets/img/bJWy8Q6s6_c96dcc4bb7c447a17fb539de89fc9d6d.png)


# Kubernetes for the Absolute Beginners - Hands-on


![](/assets/img/bJWy8Q6s6_2f0d7216eea7477a369868770679b9ce.png)

![](/assets/img/bJWy8Q6s6_2b570586aad5aba957936f382a565124.png)

![](/assets/img/bJWy8Q6s6_24ea506b1062806cebb7063d10d6805c.png)

![](/assets/img/bJWy8Q6s6_403d689d6275af47371c3209b7bbcf09.png)

![](/assets/img/bJWy8Q6s6_eaa69d1847ac0fe5725dfa104fac73b5.png)


## Certified Kubernetes Administrator (CKA) with Practice Tests

![](/assets/img/bJWy8Q6s6_8beeff5f5d825ac01364c808652bf62e.png)

* Master
	* ETCD Cluster
	* kube-apiserver
	* Kube Controller Manager
		* Node Controller
			* Node Monitor Period = 5s
			* Node Monitor Grace Period = 40s
			* POD Eviction Timeout = 5m
		* Replication Controller
	* kube-scheduler
		* Decides which pod goes on which node.
* Worker
	* kubelet
	* kube-proxy
	* Container runtime:
		* rkt
		* docker
		* cri-o
		
![](/assets/img/bJWy8Q6s6_9fbe2648112b7a62985dcca9d34967ae.png)

### Kube scheduler
![](/assets/img/bJWy8Q6s6_c05c55744b21366aea3b59f86c48106e.png)

![](/assets/img/bJWy8Q6s6_2b22b8d691a020012c5dd6360e79b600.png)

calculates the amount of resources that will be free after the pod is allocated

![](/assets/img/bJWy8Q6s6_bfe63aba0841bc8feb18f58667d3fe41.png)

### Storage

![](/assets/img/bJWy8Q6s6_1093a3ee853bd74a6203fedf2fea2b22.png)

![](/assets/img/bJWy8Q6s6_275af5bf07f8673e61afec6052a7729f.png)


![](/assets/img/bJWy8Q6s6_880542224148a383a845cd380befd199.png)

![](/assets/img/bJWy8Q6s6_b074fa392b69b5b91394357eddb5623b.png)

# Cheat Sheet

Create Nginx Pod
```bash
kubectl run nginx --image=nginx
```

Generate POD Manifest YAML file (-o yaml). Don't create it (--dry-run)
```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)

```bash
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml
```

* `kubectl get pods --namespace=dev`
* `kubectl get pods`
* `kubectl config set-context $(kubectl config current-context) --namespace=dev`
* `kubectl get pods --all-namespaces`

* General
	* Enroll for exam
		* https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/
			* [Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-candidate-handbook)
* Articles
	* https://www.contino.io/insights/the-ultimate-guide-to-passing-the-cka-exam
		* Books
			* Kubernetes in Action by Marko Luksa
			* Kubernetes Up and Running by Kelsey Hightower, Brendan Burns, Joe Beda
			* DevOps with Kubernetes by Hideto Saito, Hui-Chuan Chloe Lee, Cheng-Yang Wu
			* The Kubernetes Book by Nigel Poulton
		* Tools
			* tmux, vi, systemd, kubectl, cfssl/openssl
		* Alias
			* ```
				alias kc='kubectl'
				alias kgp='kubectl get pods'
				alias kgs='kubectl get svc'
				alias kgc='kubectl get componentstatuses’
				alias kctx='kubectl config current-context’
				alias kcon='kubectl config use-context’
				alias kgc='kubectl config get-context'
				```
    * https://www.axelerant.com/resources/team-blog/how-become-certified-kubernetes-administrator
        * Aliases: 
            * `alias k='kubectl'`
            * `alias kg='kubectl get'`
* Learn
	* https://play.instruqt.com/public	
* Commands
	* POD
		* `kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml`
		* `kubectl get pod --namespace=kube-system`
		* `kubectl run nginx --image=nginx`
		* `kubectl run nginx --image=nginx  --dry-run=client -o yaml`
		* `kubectl run custom-nginx --image=nginx --port=8080`
		* `kubectl run httpd --image=httpd:alpine --port=80 --expose`
	* Deployment
		* `kubectl create deployment --image=nginx nginx`
		* `kubectl create deployment --image=nginx nginx --dry-run -o yaml`
		* `kubectl create deployment nginx --image=nginx --replicas=4`
		* `kubectl scale deployment nginx --replicas=4`
		* `kubectl create deployment nginx --image=nginx--dry-run=client -o yaml > nginx-deployment.yaml`
	* Service
		* `kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml`
		* `kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml`
		* `kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml`
		* `kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml`
	* Namespace
		* `kubectl create namespace mysql`
		* `kubectl -n <namespace>`
		* `kubectl config set-context --current --namespace default`
	* Taints
		* `kubectl describe node kubemaster | grep Taint`
		* `kubectl taint nodes node01 spray=mortein:NoSchedule`
		* `kubectl taint nodes master/controlplane node-role.kubernetes.io/master:NoSchedule-`
	* Label Nodes
		* `kubectl label nodes <node-name> <label-key>=<label-value>`
		* `kubectl label nodes node-1 size=Large`
	* Events
		* `kubectl get events`
	* Logs
		* `kubectl logs <podname> --namespace=<namespace>`
		* `kubectl logs -f <podname> <containername> --namespace=<namespace>`
	* Secrets
		* `kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode`
* Imperative
	* Create Objects
		* kubectl run --image=nginx nginx
		* kubectl create deployment --image=nginx nginx
		* kubectl expose deployment nginx --port 80
	* Update Objects 
		* kubectl edit deployment nginx
		* kubectl scale deployment nginx --replicas=5
		* kubectl set image deployment nginx nginx=nginx:1.18
	* Deployments
		* `kubectl edit deployment <my deployment>`
* YAML
	* Resource Requirements
		* https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource
			*  mem https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
				*  ```
					apiVersion: v1
					kind: LimitRange
					metadata:
					  name: mem-limit-range
					spec:
					  limits:
					  - default:
						  memory: 512Mi
						defaultRequest:
						  memory: 256Mi
						type: Container
					```
			* cpu https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/
				* ```
					apiVersion: v1
					kind: LimitRange
					metadata:
					  name: cpu-limit-range
					spec:
					  limits:
					  - default:
						  cpu: 1
						defaultRequest:
						  cpu: 0.5
						type: Container
					```
* Useful
	* https://kubernetes.io/docs/reference/kubectl/conventions/	
	* https://twitter.com/Sh1bumi/status/1388973503400103939
		* ![](/assets/img/bJWy8Q6s6_7e695f532d4d6802a8d05dc119393097.png)






# Install Kind

https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/bin/
```

https://kind.sigs.k8s.io/docs/user/quick-start/

```bash
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
tar xzvf go1.13.linux-amd64.tar.gz -C /opt
cat <<EOF > ~/.bashrc
export PATH="/opt/go/bin/:$PATH"
export GOPATH="/opt/go/"
EOF

GO111MODULE="on" go get sigs.k8s.io/kind@v0.10.0
kind create cluster
kubectl cluster-info --context kind-kind
```

```bash
kubectl cluster-info --context kind-kind
Kubernetes control plane is running at https://127.0.0.1:46150
KubeDNS is running at https://127.0.0.1:46150/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

https://kind.sigs.k8s.io/docs/user/quick-start/#advanced

```yaml
# this config file contains all config fields with comments
# NOTE: this is not a particularly useful config file
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
# patch the generated kubeadm config with some extra settings
kubeadmConfigPatches:
- |
  apiVersion: kubelet.config.k8s.io/v1beta1
  kind: KubeletConfiguration
  evictionHard:
    nodefs.available: "0%"
# patch it further using a JSON 6902 patch
kubeadmConfigPatchesJSON6902:
- group: kubeadm.k8s.io
  version: v1beta2
  kind: ClusterConfiguration
  patch: |
    - op: add
      path: /apiServer/certSANs/-
      value: my-hostname
# 1 control plane node and 3 workers
nodes:
# the control plane node config
- role: control-plane
# the three workers
- role: worker
- role: worker
- role: worker
```

```bash
kind create cluster --config kind-example-config.yaml
```

```bash
kubectl get nodes
NAME                 STATUS   ROLES                  AGE     VERSION
kind-control-plane   Ready    control-plane,master   2m53s   v1.20.2
kind-worker          Ready    <none>                 2m17s   v1.20.2
kind-worker2         Ready    <none>                 2m17s   v1.20.2
kind-worker3         Ready    <none>                 2m17s   v1.20.2
```


# Minikube

https://minikube.sigs.k8s.io/docs/start/

```bash
yum -y install http://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
yum -y install conntrack-tools
minikube start --driver=none
```

## Install qemu kvm
https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/

```bash
yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
systemctl enable libvirtd
systemctl start libvirtd
```

https://minikube.sigs.k8s.io/docs/drivers/kvm2/


`virt-host-validate`

```bash
minikube start --driver=kvm2 --force
```

```bash
minikube node add --worker
```

```
kubectl get nodes
NAME           STATUS   ROLES                  AGE     VERSION
minikube       Ready    control-plane,master   8m46s   v1.20.2
minikube-m02   Ready    <none>                 6m34s   v1.20.2
minikube-m03   Ready    <none>                 18s     v1.20.2
```

```
minikube node list
minikube        192.168.39.142
minikube-m02    192.168.39.228
minikube-m03    192.168.39.165
```

```bash
# kubectl run nginx --image=nginx
pod/nginx created
# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          25s
# kubectl describe pod nginx
# kubectl get pods -o wide
NAME    READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          2m11s   172.17.0.2   minikube-m03   <none>           <none>
```



