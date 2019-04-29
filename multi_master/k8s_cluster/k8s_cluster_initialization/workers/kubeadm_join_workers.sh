#!/bin/bash
exec &> >(tee -a kubeadm_run.log)

# Source env vars
source env_vars.sh

# Joining the worker to the cluster using the token generated from the kubeadm init on master01
./join_worker.sh

sudo mkdir -p $HOME/.kube
sudo mv /home/${Pi_USERNAME}/config .kube

kubectl label node $HOSTNAME node-role.kubernetes.io/worker=worker

echo "Wait a bit for the worker node to join the cluster (sleeping 45s)"
sleep 45

kubectl get nodes
