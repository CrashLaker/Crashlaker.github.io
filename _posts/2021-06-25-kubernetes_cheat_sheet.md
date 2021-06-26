---
layout: post
title: "Kubernetes Cheat Sheet"
comments: true
date: "2021-06-25 03:33:24.858000+00:00"
---


## Install


### All
```bash
# Kickstart
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
systemctl stop firewalld
systemctl disable firewalld
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
yum -y install epel-release
yum -y install git screen htop vim nmap

# Add Kubernetes Repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum -y check-update
yum install kubeadm docker -y
systemctl restart docker && systemctl enable docker
systemctl restart kubelet && systemctl enable kubelet


reboot
```



### Master
```bash
kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> /etc/profile.d/kubectl_bashcompletion.sh
```

`kubeadm join 192.168.15.16:6443 --token x70oy2.tb18cxjd8bdkr0fd --discovery-token-ca-cert-hash sha256:2f14dc33fd651488523cd90437bb11f97b5340ae15322dc7f7a5464a94b53a6d`

#### Allow workload on master
```bash
# get master name
kubectl get nodes

kubectl taint nodes <master hostname> node-role.kubernetes.io/master-
# the - at the end is expected. instructs kubectl to "remove" the taint
```


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


