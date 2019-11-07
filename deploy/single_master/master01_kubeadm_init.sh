#!/bin/bash
exec &> >(tee -a kubeadm_run.log)

# Source env vars
source ARMadillo/deploy/single_master/env_vars.sh

# Create kubeadm config file and start kubeadm init
sudo cat <<EOT >> kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
EOT

echo "Wait, pulling k8s images needed..."
sudo kubeadm config images pull
sudo kubeadm init --config=kubeadm-config.yaml

# Creating the script for joining the worker nodes to cluster
grep "kubeadm join\|--discovery-token-ca-cert-hash" kubeadm_run.log > join_worker.sh
sed -i '3,4d' join_worker.sh
sed -i 's/^ *//' join_worker.sh
sed -i '1s/^/sudo /' join_worker.sh
sudo chmod +x join_worker.sh

# Creating .kube directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Installing Weave CNI
sudo sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Copy join_worker script and cluster config file to workers 
for host in ${WORKERS_HOSTS}; do
    sudo sshpass -p $Pi_PASSWORD rsync -p -a --chmod=+x join_worker.sh $Pi_USERNAME@$host:
    sudo sshpass -p $Pi_PASSWORD rsync -a .kube/config $Pi_USERNAME@$host:
done

# Getting status
echo "Almost there, waiting for all pods to run and for the master node to be in 'Ready' state (sleeping 90s)"
sleep 90

kubectl get pod -n kube-system
kubectl get nodes



# Cleanup
mkdir -p ARMadillo/artifacts
sudo mv join_worker.sh ARMadillo/artifacts
sudo mv config ARMadillo/artifacts
sudo mv kubeadm_run.log ARMadillo/artifacts
sudo rm -f admin.conf 