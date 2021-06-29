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
    * https://computingforgeeks.com/kubectl-cheat-sheet-for-kubernetes-cka-exam-prep/
        * start a temporary pod that dies on exit
            * `kubectl run --rm -it --image=<image> <podname> -- sh`
        * create namespace
            * `kubectl create namespace <name>`
            * `kubectl create ns <name>`
        * starting session to the pod
            * `kubectl exec --stdin --ty ubuntu -- sh`
            * `kubectl exec --stdin --ty ubuntu -- /bin/bash`
            * `kubectl exec --stdin --ty ubuntu -- ls -lt /etc/hosts`
        * run pod
            * `kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml`
            * `kubectl run nginx --image=nginx --restart=Never --limits='cpu=300m,memory=512Mi' --dry-run=client -o yaml`
            * `kubectl run nginx --image=nginx --restart=Never --requests='cpu=100m,memory=256Mi' --limits='cpu=300m,memory=512Mi' --dry-run=client -o yaml`
            * `kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml >nginx-pod.yaml`


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
    * https://www.reddit.com/r/kubernetes/comments/ndwgkr/the_story_of_3_attempts_at_cka_and_how_killersh/
        * https://brownfield.dev/post/2021-05-13-series-cert-cka/
            * 2 browser tabs, one for the exam and one for https://kubernetes.io/docs
                * Get good with vim
                * Use the docs for references
                * Learn how to confirm since the test won't help you
                * `kubectl`, `etcdtl`, `systemctl` are the important commands
            * Killer.sh CKA Simulator
                * https://killer.sh/cka
    * My views on CKA
        * https://www.reddit.com/r/kubernetes/comments/nejmo5/my_views_on_cka/
    * https://apaarshrm39.medium.com/k8s-speed-run-how-i-aced-ck-ad-s-in-35-days-with-a-day-occasionally-night-job-fbf60d2ebe0c
        * ```
            alias k="kubectl"
            alias kn="kubectl config set-context --current --namespace"
            export y="--dry-run=client -o yaml"
          ```
        * **Make sure you are aware of these directories**: I came across an article which summarized all the important directories in a single place, give it a look: https://brandonwillmott.com/2020/10/01/important-directories-to-know-for-kubernetes-cka-exam/
        * **Practice and Understand ETCD backup thoroughly**: I see people lost in this topic the most, practice it again and again, the backup as well as restore, don’t forget to mount the location of the restored backup on the etcd static pod. Refer this link: https://github.com/mmumshad/kubernetes-cka-practice-test-solution-etcd-backup-and-restore
    * https://www.reddit.com/r/kubernetes/comments/nrs1ry/today_i_got_my_cka_here_are_some_tips/
    * https://medium.com/swlh/my-take-towards-cka-ckad-september-curriculum-update-tips-ff38e7585447
        * **Cluster Maintenance(11%) + Installation, Configuration & Validation(12%) = Cluster Architecture, Installation & Configuration(25%)**
            * Manage role-based access control (RBAC) [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
            * Use Kubeadm to install a basic cluster [create cluster using kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
            * Manage a highly-available Kubernetes cluster [highly available cluster](https://kubernetes.io/docs/tasks/administer-cluster/highly-available-master/)
            * Provision underlying infrastructure to deploy a Kubernetes cluster
            * Perform a version upgrade on a Kubernetes cluster using Kubeadm [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
            * Implement etcd backup and restore [ETCD backup and restore](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)
        * **Networking(11%) + Core Concepts(19%) = Services & Networking(20%)**
            * Understand host networking configuration on the cluster nodes [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/), [Node communication](https://kubernetes.io/docs/concepts/architecture/control-plane-node-communication/)
            * Understand connectivity between Pods [Pod to Pod Communication](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
            * Understand ClusterIP, NodePort, LoadBalancer service types and endpoints [Services](https://kubernetes.io/docs/concepts/services-networking/service/)
            * Know how to use Ingress controllers and Ingress resources [Ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/), [Ingress resource](https://kubernetes.io/docs/concepts/services-networking/ingress/)
            * Know how to configure and use CoreDNS [CoreDNS](https://kubernetes.io/docs/tasks/administer-cluster/coredns/)
            * Choose an appropriate container network interface plugin [network plugins](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)
        * **Logging/Monitoring(5%) + Troubleshooting 10% = Troubleshooting(30%)**
            * Troubleshoot application failure: [Troubleshooting application](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/), [debug Pod failure](https://kubernetes.io/docs/tasks/debug-application-cluster/determine-reason-pod-failure/), [debug Init containers](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-init-containers/)
            * Troubleshoot cluster component failure: [Troubleshoot clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/), [troubleshoot kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)
            * Troubleshoot networking: [debug DNS resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/), [debug service](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/)
        * **Scheduling(5%) + Application Lifecycle Management(8%) = Workloads & Scheduling(15%)**
            * Understand deployments and how to perform rolling update and rollbacks [Perform a Rollback on a DaemonSet](https://kubernetes.io/docs/tasks/manage-daemon/rollback-daemon-set/)
            * Use ConfigMaps and Secrets to configure applications [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/), [Distribute Credentials Securely Using Secrets](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/)
            * Know how to scale applications [Scaling your application](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#scaling-your-application), [Scale a StatefulSet](https://kubernetes.io/docs/tasks/run-application/scale-stateful-set/)
            * Understand the primitives used to create robust, self-healing [Deploy an App](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/)
            * Understand how resource limits can affect Pod scheduling [Assign CPU Resources to Containers and Pods](https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/), [Assign Memory Resources to Containers and Pods](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/)
            * Awareness of manifest management and common templating tools
        * **Storage(7%) = Storage(10%)**
            * Understand storage classes, persistent volumes [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/), [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/), [Persistent Volume Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
            * Understand volume mode, access modes and reclaim policies for volumes [Volume Modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#volume-mode), [Access Modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes), [Update Reclaim Policy](https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/)
            * Understand persistent volume claims primitive
            * Know how to configure applications with persistent storage [Storage](https://kubernetes.io/docs/concepts/storage/), [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* Useful
    * https://github.com/cloudogu/k8s-diagrams?utm_sq=ggoh6xujj8
* Learn
	* https://play.instruqt.com/public	
* Book
    * Kubernetes: Preparing for the CKA and CKAD Certifications
        * Curriculum CKA 1.19: Sep 2020
            * **Cluster Architecture, Installation, and Configuration (25%)**
                * [ ] Manage role-based access control (RBAC) - Authorization Chapter 11
                * [ ] Use kubeadm to install a basic cluster - Chapter 1
                * [ ] Manage a highly available Kubernetes cluster - Chapter 1
                * [ ] Provision underlying infrastructure to deploy a Kubernetes cluster - Chapter 1
                * [ ] Perform a version upgrade on a Kubernetes cluster using kubeadm - Chapter 15
                * [ ] Implement etcd backup and restore - "Back Up a Cluster", "Restore a Cluster" Chapter 15
            * [ ] **Workloads and Scheduling (15%)**
                * [ ] Understand deployments and how to perform rolling update and rollbacks - "ReplicaSet Controller", "Deployment Controller", "Update and Rollback", and "Deployment Strategies", Chapter 5
                * [ ] Use ConfigMaps and Secrets to configure applications - Chapter 6
                * [ ] Know how to scale applications - Chapter 7
                * [ ] Understand the primitives used to create robust, self-healing, application deployments - Chapter 8
                * [ ] Understand how to resource limits can affect Pod scheduling - "Resource Requests" Chapter 9
                * [ ] Awareness of manifest management and common templating tools - "Helm", "Kustomize", Chapter 16
            * [ ] **Services and Networking (20%)**
                * [ ] Understand host networking configuration on the cluster nodes - Chapter 1
                * [ ] Understand connectivity between Pods - Chapter 1
                * [ ] Understand ClusterIP, NodePort, and LoadBalancer service types and endpoints - Chapter 10
                * [ ] Know how to use Ingress controllers and Ingress resources - Chapter 10
                * [ ] Know how to configure and use CoreDNS - Chapter 1
                * [ ] Choose an appropriate container network interface plugin - Chapter 1
            * [ ] **Storage (10%)**
                * [ ] Understand storage classes and persistent volumes - Chapter 12
                * [ ] Understand mode, access modes, and reclaim policies for volumes - "Access Modes", "Claiming a Persistent Volume" Chapter 12
                * [ ] Understand persistent volume claims primitive - "Claiming a Persistent Volume" Chapter 12
                * [ ] Know how to configure applications with persistent storage - "Persistent Volume" Chapter 12
            * [ ] **Troubleshooting (30%)**
                * [ ] Evaluate cluster and node logging - Chapter 2
                * [ ] Understand how to monitor applications - "Auto-scaling" Chapter 7; "kubectl" Chapter 16
                * [ ] Manage container stdout and stderr logs - Logging in the Chapter 14
                * [ ] Troubleshoot application failure - Basic logging, "kubectl", Chapter 16
                * [ ] Troubleshoot cluster component failure - Chapter 2
                * [ ] Troubleshoot networking - Chapter 2, Chapter 10, "kubectl", Chapter 16
* Commands
	* POD
		* `kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml`
		* `kubectl get pod --namespace=kube-system`
		* `kubectl run nginx --image=nginx`
		* `kubectl run nginx --image=nginx  --dry-run=client -o yaml`
		* `kubectl run custom-nginx --image=nginx --port=8080`
		* `kubectl run httpd --image=httpd:alpine --port=80 --expose`
		* `kubectl -n elastic-stack exec -it app cat /log/app.log`
	* Deployment
		* `kubectl create deployment --image=nginx nginx`
		* `kubectl create deployment --image=nginx nginx --dry-run -o yaml`
		* `kubectl create deployment nginx --image=nginx --replicas=4`
		* `kubectl scale deployment nginx --replicas=4`
		* `kubectl create deployment nginx --image=nginx--dry-run=client -o yaml > nginx-deployment.yaml`
	    * `kubectl edit deployment <name>`
   * ConfigMaps
        * `kubectl create configmap`
            * `<config-name> --from-literal=<key>=<value>`
        * `kubectl create configmap <config-name> --from-file=<path to file>`
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
	    * `echo -n 'password' | base64`
	    * `echo -n 'password' | base64 --decode`
	    * `kubectl get secrets`
	    * `kubectl describe secrets`
	    * `kubectl get secret app-secret -o yaml`
		* `kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode`
		* `kubectl create secret generic app-secret --from-literal=DB_Host=mysql`
		* `kubectl create secret generic app-secret --from-file=<filepath>`
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



