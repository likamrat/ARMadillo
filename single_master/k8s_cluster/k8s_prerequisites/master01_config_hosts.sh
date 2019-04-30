#!/bin/bash

# Source env vars
source env_vars.sh

# Change the hostname
sudo hostnamectl --transient set-hostname $MASTER01_HOSTNAME
sudo hostnamectl --static set-hostname $MASTER01_HOSTNAME
sudo hostnamectl --pretty set-hostname $MASTER01_HOSTNAME
sudo sed -i s/raspberrypi/$MASTER01_HOSTNAME/g /etc/hosts

# Set the static ip
sudo cat <<EOT >> /etc/dhcpcd.conf
interface eth0
static ip_address=$MASTER01_IP/24
static routers=$DNS
static domain_name_servers=$DNS
EOT

sudo sh -c "cat >>/etc/hosts <<EOF
$MASTER01_IP    $MASTER01_HOSTNAME
$WORKER01_IP    $WORKER01_HOSTNAME
$WORKER02_IP    $WORKER02_HOSTNAME
$WORKER03_IP    $WORKER03_HOSTNAME
$WORKER04_IP    $WORKER04_HOSTNAME
$WORKER05_IP    $WORKER05_HOSTNAME
EOF
"

# Getting rid of Known Hosts functionality
sudo sh -c "cat >>/etc/ssh/ssh_config <<EOF
StrictHostKeyChecking no 
UserKnownHostsFile /dev/null
LogLevel QUIET
EOF
"

sudo curl -sSL get.docker.com | sh
sudo usermod $Pi_USERNAME -aG docker

sudo reboot
