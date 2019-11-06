#!/bin/bash

# Source env vars
source armadillo/deploy/multi_master/env_vars.sh

# Change the hostname
sudo hostnamectl --transient set-hostname $MASTER03_HOSTNAME
sudo hostnamectl --static set-hostname $MASTER03_HOSTNAME
sudo hostnamectl --pretty set-hostname $MASTER03_HOSTNAME
sudo sed -i s/raspberrypi/$MASTER03_HOSTNAME/g /etc/hosts

# Set the static ip
sudo cat <<EOT >> /etc/dhcpcd.conf
interface eth0
static ip_address=$MASTER03_IP/24
static routers=$DNS
static domain_name_servers=$DNS
EOT

sudo sh -c "cat >>/etc/hosts <<EOF
$LOAD_BALANCER_IP   $LOAD_BALANCER_HOSTNAME
$MASTER01_IP        $MASTER01_HOSTNAME
$MASTER02_IP        $MASTER02_HOSTNAME
$MASTER03_IP        $MASTER03_HOSTNAME
$WORKER01_IP        $WORKER01_HOSTNAME
$WORKER02_IP        $WORKER02_HOSTNAME
EOF
"

# Getting rid of Known Hosts functionality
sudo sh -c "cat >>/etc/ssh/ssh_config <<EOF
StrictHostKeyChecking no 
UserKnownHostsFile /dev/null
LogLevel QUIET
EOF
"

# Follow kubernetes release notes for the current validated docker versions @ https://kubernetes.io/docs/setup/release/notes/
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.6-3_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_18.09.7~3-0~debian-buster_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_18.09.7~3-0~debian-buster_armhf.deb

sudo dpkg -i containerd.io_1.2.6-3_armhf.deb
sudo dpkg -i docker-ce-cli_18.09.7~3-0~debian-buster_armhf.deb
sudo dpkg -i docker-ce_18.09.7~3-0~debian-buster_armhf.deb

sudo usermod $Pi_USERNAME -aG docker

sudo reboot
