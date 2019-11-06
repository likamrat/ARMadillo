# Set env vars

# Pi creds
export  Pi_USERNAME="pi"          # Pi default OS username is "pi"
export  Pi_PASSWORD="raspberry"   # Pi default OS password is "raspberry"

# Network parameters
export  MASTER01_HOSTNAME=armadillo-k8s-master01
export  WORKER01_HOSTNAME=armadillo-k8s-worker01
export  WORKER02_HOSTNAME=armadillo-k8s-worker02
export  WORKER03_HOSTNAME=armadillo-k8s-worker03
export  WORKER04_HOSTNAME=armadillo-k8s-worker04
export  WORKER05_HOSTNAME=armadillo-k8s-worker05
export  MASTER01_IP=192.168.1.81
export  WORKER01_IP=192.168.1.82
export  WORKER02_IP=192.168.1.83
export  WORKER03_IP=192.168.1.84
export  WORKER04_IP=192.168.1.85
export  WORKER05_IP=192.168.1.86
export  DNS=192.168.1.1

# Change based on number of workers
export MASTERS_HOSTS="$MASTER01_HOSTNAME"
export MASTERS_IPS="$MASTER01_IP"
export WORKERS_HOSTS="$WORKER01_HOSTNAME $WORKER02_HOSTNAME $WORKER03_HOSTNAME $WORKER04_HOSTNAME $WORKER05_HOSTNAME"
export WORKERS_IPS="$WORKER01_IP $WORKER02_IP $WORKER03_IP $WORKER04_IP $WORKER05_IP"
