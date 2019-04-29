#!/bin/bash

source env_vars.sh

sudo apt update
sudo apt install nfs-common -qy

sudo mkdir $CLIENT_NFS_PV -p
sudo mount $NFS_SERVER:$SERVER_NFS_MOUNT $CLIENT_NFS_PV

## Change to param
sudo sh -c "cat >>/etc/fstab <<EOF
$NFS_SERVER:$SERVER_NFS_MOUNT    $CLIENT_NFS_PV   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
EOF
"
