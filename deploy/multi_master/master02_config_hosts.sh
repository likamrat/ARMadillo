#!/bin/bash

# Source env vars
source ARMadillo/deploy/multi_master/env_vars.sh

# Change the hostname
sudo hostnamectl --transient set-hostname $MASTER02_HOSTNAME
sudo hostnamectl --static set-hostname $MASTER02_HOSTNAME
sudo hostnamectl --pretty set-hostname $MASTER02_HOSTNAME
sudo sed -i s/raspberrypi/$MASTER02_HOSTNAME/g /etc/hosts

# Set the static ip
sudo cat <<EOT >> /etc/dhcpcd.conf
interface eth0
static ip_address=$MASTER02_IP/24
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

# Setup daemon
sudo bash -c 'cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF'

sudo mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo apt-mark hold "containerd.io"
sudo apt-mark hold "docker-ce"
sudo apt-mark hold "docker-ce-cli"

sudo rm -f *docker* *containerd*

sudo reboot
