# Set env vars

# Pi creds
export  Pi_USERNAME="pi"          # Pi default OS username is "pi"
export  Pi_PASSWORD="raspberry"   # Pi default OS password is "raspberry"

# Network parameters
export  LOAD_BALANCER_HOSTNAME=armadillo-haproxy
export  LOAD_BALANCER_PORT=6443
export  MASTER01_HOSTNAME=armadillo-master01
export  MASTER02_HOSTNAME=armadillo-master02
export  MASTER03_HOSTNAME=armadillo-master03
export  WORKER01_HOSTNAME=armadillo-worker01
export  WORKER02_HOSTNAME=armadillo-worker02
export  WORKER03_HOSTNAME=armadillo-worker03
export  LOAD_BALANCER_IP=192.168.1.90
export  MASTER01_IP=192.168.1.81
export  MASTER02_IP=192.168.1.82
export  MASTER03_IP=192.168.1.83
export  WORKER01_IP=192.168.1.84
export  WORKER02_IP=192.168.1.85
export  WORKER03_IP=192.168.1.85
export  DNS=192.168.1.1

# haproxy certificates (change according to example below)
export  C=US
export  L=Redmond
export  O=Kubernetes
export  OU=CA
export  ST=WA

# No need to change unless you have more then 3 masters and 2 workers
export MASTERS_HOSTS="$MASTER01_HOSTNAME $MASTER02_HOSTNAME $MASTER03_HOSTNAME"
export MASTERS_IPS="$MASTER01_IP $MASTER02_IP $MASTER03_IP"
export WORKERS_HOSTS="$WORKER01_HOSTNAME $WORKER02_HOSTNAME $WORKER03_HOSTNAME"
export WORKERS_IPS="$WORKER01_IP $WORKER02_IP $WORKER03_IP"

# The following env vars will be used in the remote init process
# No need to change unless you have more then 3 masters and 2 workers 
export MASTERS_HOSTS_INIT="$MASTER02_HOSTNAME $MASTER03_HOSTNAME"
export MASTERS_IPS_INIT="$MASTER02_IP $MASTER03_IP"