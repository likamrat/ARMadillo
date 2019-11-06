# Set env vars

# Pi creds
export  Pi_USERNAME="Pi OS USERNAME HERE"   # Pi default OS username is "pi"
export  Pi_PASSWORD="Pi OS PASSWORD HERE"   # Pi default OS password is "raspberry"

# Network parameters
export  MASTER01_HOSTNAME=<k8s_MASTER_01 HOSTNAME HERE>
export  WORKER01_HOSTNAME=<k8s_WORKER_01 HOSTNAME HERE>
export  WORKER02_HOSTNAME=<k8s_WORKER_02 HOSTNAME HERE>
export  WORKER03_HOSTNAME=<k8s_WORKER_03 HOSTNAME HERE>
export  WORKER04_HOSTNAME=<k8s_WORKER_04 HOSTNAME HERE>
export  WORKER05_HOSTNAME=<k8s_WORKER_05 HOSTNAME HERE>
export  MASTER01_IP=<k8s_MASTER_01 IP HERE>
export  WORKER01_IP=<k8s_WORKER_01 IP HERE>
export  WORKER02_IP=<k8s_WORKER_02 IP HERE>
export  WORKER03_IP=<k8s_WORKER_03 IP HERE>
export  WORKER04_IP=<k8s_WORKER_04 IP HERE>
export  WORKER05_IP=<k8s_WORKER_05 IP HERE>
export  DNS=<DNS SERVER IP HERE>

# Docker version
# Follow kubernetes release notes for the current validated docker versions @ https://kubernetes.io/docs/setup/release/notes/
export VERSION=18.09 

# Change based on number of workers
export MASTERS_HOSTS="$MASTER01_HOSTNAME"
export MASTERS_IPS="$MASTER01_IP"
export WORKERS_HOSTS="$WORKER01_HOSTNAME $WORKER02_HOSTNAME $WORKER03_HOSTNAME $WORKER04_HOSTNAME $WORKER05_HOSTNAME"
export WORKERS_IPS="$WORKER01_IP $WORKER02_IP $WORKER03_IP $WORKER04_IP $WORKER05_IP"
