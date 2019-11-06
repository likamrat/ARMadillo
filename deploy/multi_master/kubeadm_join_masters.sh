#!/bin/bash
exec &> >(tee -a kubeadm_run.log)

# Source env vars
source ARMadillo/deploy/multi_master/env_vars.sh

# Move certs generated by kubeadm which was copied from master01
sudo mkdir -p /etc/kubernetes/pki/etcd
sudo mv /home/${Pi_USERNAME}/ca.crt /etc/kubernetes/pki/
sudo mv /home/${Pi_USERNAME}/ca.key /etc/kubernetes/pki/
sudo mv /home/${Pi_USERNAME}/sa.pub /etc/kubernetes/pki/
sudo mv /home/${Pi_USERNAME}/sa.key /etc/kubernetes/pki/
sudo mv /home/${Pi_USERNAME}/front-proxy-ca.crt /etc/kubernetes/pki/
sudo mv /home/${Pi_USERNAME}/front-proxy-ca.key /etc/kubernetes/pki/
sudo mv /home/${Pi_USERNAME}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
sudo mv /home/${Pi_USERNAME}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key
sudo mv /home/${Pi_USERNAME}/admin.conf /etc/kubernetes/admin.conf

# Joining the master to the cluster using the token generated from the kubeadm init on master01
echo "Wait, pulling k8s images needed..."
sudo kubeadm config images pull
./join_master.sh

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Almost there, wait a bit for the master node to join the cluster (sleeping 45s)"
sleep 75

kubectl get nodes
