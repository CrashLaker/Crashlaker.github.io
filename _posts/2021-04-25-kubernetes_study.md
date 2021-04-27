---
layout: post
title: "Kubernetes Study"
comments: true
date: "2021-04-25 22:19:29.465000+00:00"
---


* https://www.udemy.com/course/learn-kubernetes/
* https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/
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






# Install Kind

https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
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










