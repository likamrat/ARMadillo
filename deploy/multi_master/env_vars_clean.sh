# Set env vars

# Pi creds
export  Pi_USERNAME="Pi OS USERNAME HERE"   # Pi default OS username is "pi"
export  Pi_PASSWORD="Pi OS PASSWORD HERE"   # Pi default OS password is "raspberry"

# Network parameters
export  LOAD_BALANCER_HOSTNAME=<LB HOSTNAME HERE>
export  MASTER01_HOSTNAME=<k8s_MASTER_01 HOSTNAME HERE>
export  MASTER02_HOSTNAME=<k8s_MASTER_02 HOSTNAME HERE>
export  MASTER03_HOSTNAME=<k8s_MASTER_03 HOSTNAME HERE>
export  WORKER01_HOSTNAME=<k8s_WORKER_01 HOSTNAME HERE>
export  WORKER02_HOSTNAME=<k8s_WORKER_02 HOSTNAME HERE>
export  LOAD_BALANCER_IP=<LB IP HERE>
export  MASTER01_IP=<k8s_MASTER_01 IP HERE>
export  MASTER02_IP=<k8s_MASTER_02 IP HERE>
export  MASTER03_IP=<k8s_MASTER_03 IP HERE>
export  WORKER01_IP=<k8s_WORKER_01 IP HERE>
export  WORKER02_IP=<k8s_WORKER_01 IP HERE>
export  DNS=<DNS SERVER IP HERE>

# haproxy certificates (change according to example below)
export  C=US
export  L=Redmond
export  O=Kubernetes
export  OU=CA
export  ST=WA

# Docker version
# Follow kubernetes release notes for the current validated docker versions @ https://kubernetes.io/docs/setup/release/notes/
export VERSION=18.09 

# No need to change unless you have more then 3 masters and 2 workers
export MASTERS_HOSTS="$MASTER01_HOSTNAME $MASTER02_HOSTNAME $MASTER03_HOSTNAME"
export MASTERS_IPS="$MASTER01_IP $MASTER02_IP $MASTER03_IP"
export WORKERS_HOSTS="$WORKER01_HOSTNAME $WORKER02_HOSTNAME"
export WORKERS_IPS="$WORKER01_IP $WORKER02_IP"
