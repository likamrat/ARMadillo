#!/bin/bash
exec &> >(tee -a kubeadm_run.log)

# Source env vars
source ARMadillo/deploy/multi_master/env_vars.sh

# Joining the worker to the cluster using the token generated from the kubeadm init on master01
sudo ./join_worker.sh

sudo mkdir -p $HOME/.kube
sudo mv /home/${Pi_USERNAME}/config .kube

kubectl label node $HOSTNAME node-role.kubernetes.io/worker=worker

# Getting status
echo "Wait a bit for the worker node to join the cluster (sleeping 120s)"
sleep 120

kubectl get nodes

# # Cleanup
# mkdir -p ARMadillo/artifacts
# sudo mv join_worker.sh ARMadillo/artifacts
# sudo mv kubeadm_run.log ARMadillo/artifacts