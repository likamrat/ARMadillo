#!/bin/bash

source env_vars.sh

sudo apt-get update
sudo apt-get install nfs-kernel-server -qy

sudo mkdir $SERVER_NFS_MOUNT -p
sudo chown nobody:nogroup $SERVER_NFS_MOUNT

sudo sh -c "cat >>/etc/exports <<EOF
$SERVER_NFS_MOUNT     $Pi_SUBNET(rw,sync,no_subtree_check)
EOF
"

sudo systemctl restart nfs-kernel-server
