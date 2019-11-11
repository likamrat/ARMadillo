#!/bin/bash

# Sourcing env vars
source ARMadillo/deploy/multi_master/env_vars.sh

# Updating...
sudo apt-get update
sudo apt-get upgrade -y

# Installing sshpass
sudo apt-get install sshpass -qy

# Installing kubeadm and it's perquisites
# Disabling swap memory
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm

echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to /boot/cmdline.txt

sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo $orig | sudo tee /boot/cmdline.txt

sudo swapoff -a
sudo systemctl disable dphys-swapfile

# Installing containerd & docker
# Follow kubernetes release notes for the current validated docker versions @ https://kubernetes.io/docs/setup/release/notes/
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.6-3_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_18.09.7~3-0~debian-buster_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_18.09.7~3-0~debian-buster_armhf.deb

sudo dpkg -i containerd.io_1.2.6-3_armhf.deb
sudo dpkg -i docker-ce-cli_18.09.7~3-0~debian-buster_armhf.deb
sudo dpkg -i docker-ce_18.09.7~3-0~debian-buster_armhf.deb

sudo usermod $Pi_USERNAME -aG docker

# Setup daemon for kubeadm installation
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

# Restart docker
# Preventing containerd docker packages to get updated
# Cleanup
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo apt-mark hold "containerd.io"
sudo apt-mark hold "docker-ce"
sudo apt-mark hold "docker-ce-cli"

sudo rm -f *docker* *containerd*

# Setting iptables to legacy mode
# https://github.com/weaveworks/weave/issues/3717
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Updating...
sudo apt-get update
sudo apt-get upgrade -y
sudo SKIP_WARNING=1 rpi-update

# Change the hostname
sudo hostnamectl --transient set-hostname $WORKER01_HOSTNAME
sudo hostnamectl --static set-hostname $WORKER01_HOSTNAME
sudo hostnamectl --pretty set-hostname $WORKER01_HOSTNAME
sudo sed -i s/raspberrypi/$WORKER01_HOSTNAME/g /etc/hosts

# Set the static ip
sudo cat <<EOT >> /etc/dhcpcd.conf
interface eth0
static ip_address=$WORKER01_IP/24
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

sudo reboot
