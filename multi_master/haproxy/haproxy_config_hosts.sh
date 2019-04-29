#!/bin/bash

# Source env vars
source env_vars.sh

# Change the hostname
sudo hostnamectl --transient set-hostname $LOAD_BALANCER_HOSTNAME
sudo hostnamectl --static set-hostname $LOAD_BALANCER_HOSTNAME
sudo hostnamectl --pretty set-hostname $LOAD_BALANCER_HOSTNAME
sudo sed -i s/raspberrypi/$LOAD_BALANCER_HOSTNAME/g /etc/hosts

# Set the static ip
sudo cat <<EOT >> /etc/dhcpcd.conf
interface eth0
static ip_address=$LOAD_BALANCER_IP/24
static routers=$DNS
static domain_name_servers=$DNS
EOT

# Adding hosts file records
sudo sh -c "cat >>/etc/hosts <<EOF
$LOAD_BALANCER_IP     $LOAD_BALANCER_HOSTNAME
$MASTER01_IP    $MASTER01_HOSTNAME
$MASTER02_IP    $MASTER02_HOSTNAME
$MASTER03_IP    $MASTER03_HOSTNAME
$WORKER01_IP    $WORKER01_HOSTNAME
$WORKER02_IP    $WORKER02_HOSTNAME
EOF
"

# Getting rid of Known Hosts functionality
sudo sh -c "cat >>/etc/ssh/ssh_config <<EOF
StrictHostKeyChecking no 
UserKnownHostsFile /dev/null
LogLevel QUIET
EOF
"

sudo reboot
