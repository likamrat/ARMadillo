#!/bin/bash

source env_vars.sh

sudo apt update
sudo apt install nfs-kernel-server -qy

curl https://rclone.org/install.sh | sudo bash

sudo mkdir $SERVER_NFS_MOUNT -p
sudo chown nobody:nogroup $SERVER_NFS_MOUNT


sudo sh -c "cat >>/etc/exports <<EOF
$SERVER_NFS_MOUNT     $Pi_SUBNET(rw,sync,no_subtree_check)
EOF
"

sudo systemctl restart nfs-kernel-server
