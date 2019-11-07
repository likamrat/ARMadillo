#!/bin/bash

# Source env vars
source ARMadillo/deploy/multi_master/env_vars.sh

# This installs the base instructions up to the point of joining / creating a cluster

sudo apt-mark hold "containerd.io"
sudo apt-mark hold "docker-ce"
sudo apt-mark hold "docker-ce-cli"

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install sshpass -qy

# Disable swap
sudo swapoff -a
sudo systemctl disable dphys-swapfile

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm

echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to /boot/cmdline.txt

sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo $orig | sudo tee /boot/cmdline.txt

# Setting iptables to legacy mode
# https://github.com/weaveworks/weave/issues/3717
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

sudo reboot
