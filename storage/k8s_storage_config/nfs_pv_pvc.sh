#!/bin/bash

source env_vars.sh

sudo cat <<EOT >> nfs_pv_pvc.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv_01 
spec:
  capacity:
    storage: 5Gi 
  accessModes:
  - ReadWriteMany 
  nfs: 
    path: $SERVER_NFS_MOUNT 
    server: $NFS_SERVER
  persistentVolumeReclaimPolicy: Recycle 
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc_nfs
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: 1Gi
EOT

kubectl create -f nfs_pv_pvc.yaml
