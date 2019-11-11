#!/bin/bash

sudo kubeadm reset -f
sudo rm -Rf /var/lib/kubelet
sudo rm -Rf /etc/kubernetes
sudo rm -Rf /var/lib/etcd /var/lib/kubelet /etc/cni/net.d /var/lib/dockershim /var/run/kubernetes /var/lib/cni
sudo rm -Rf $HOME/.kube
sudo rm -f kubeadm-config.yaml
sudo rm -f join_master.sh
sudo rm -f join_worker.sh
sudo rm -f kubeadm_run.log
sudo rm -f config
docker rmi $(docker images --filter=reference="*weaveworks/weave*" -q)
sudo rm -Rf ARMadillo 
git clone https://github.com/likamrat/ARMadillo.git
