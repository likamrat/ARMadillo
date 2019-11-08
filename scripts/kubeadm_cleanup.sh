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
sudo rm -f ca.crt
sudo rm -f ca.key
sudo rm -f sa.key
sudo rm -f sa.pub
sudo rm -f front-proxy-ca.crt
sudo rm -f front-proxy-ca.key
sudo rm -f etcd-ca.crt
sudo rm -f etcd-ca.key
sudo rm -f admin.conf
sudo rm -f join_master.sh
sudo rm -f join_worker.sh
sudo rm -f config
sudo rm -f cleanup.sh
sudo rm -Rf ARMadillo 
git clone https://github.com/likamrat/ARMadillo.git
