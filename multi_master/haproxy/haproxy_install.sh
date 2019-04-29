#!/bin/bash

# Source env vars
source env_vars.sh

# Install sshpass, cfssl and cfssljson
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install sshpass -qy

wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-arm \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-arm

sudo chmod +x cfssl*
sudo mv cfssl_linux-arm /usr/local/bin/cfssl
sudo mv cfssljson_linux-arm /usr/local/bin/cfssljson
cfssl version

# Install haproxy
sudo apt-get install haproxy -y
sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.backup

# Create haproxy config file
sudo cat <<EOT >> haproxy.cfg
defaults
  timeout connect 5000ms
  timeout check 5000ms
  timeout server 30000ms
  timeout client 30000

global
  tune.ssl.default-dh-param 2048

listen stats
  bind :9000
  mode http
  stats enable
  stats hide-version
  stats realm Haproxy\ Statistics
  stats uri /stats

listen apiserver
  bind :6443
  mode tcp
  balance roundrobin
  option httpchk GET /healthz
  http-check expect string ok

  server $MASTER01_HOSTNAME $MASTER01_IP:6443 check check-ssl verify none
  server $MASTER02_HOSTNAME $MASTER02_IP:6443 check check-ssl verify none
  server $MASTER03_HOSTNAME $MASTER03_IP:6443 check check-ssl verify none
  server $WORKER01_HOSTNAME $WORKER01_IP:6443 check check-ssl verify none
  server $WORKER02_HOSTNAME $WORKER02_IP:6443 check check-ssl verify none
EOT

sudo mv haproxy.cfg /etc/haproxy

sudo systemctl restart haproxy
