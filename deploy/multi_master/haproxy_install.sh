#!/bin/bash

# Source env vars
source armadillo/deploy/multi_master/env_vars.sh

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

# Creating a certificate authority
sudo cat <<EOT >> ca-config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOT

# Create the certificate authority signing request configuration file
sudo cat <<EOT >> ca-csr.json
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "$C",
    "L": "$L",
    "O": "$O",
    "OU": "$OU",
    "ST": "$ST"
  }
 ]
}
EOT

# Generate the certificate authority certificate and private key
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
ls -la
openssl x509 -in ca.pem -text -noout

#Generate the single Kubernetes TLS Cert
sudo cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "$LOAD_BALANCER_HOSTNAME",
    "$MASTER01_HOSTNAME",
    "$MASTER02_HOSTNAME",
    "$MASTER03_HOSTNAME",
    "$WORKER01_HOSTNAME",
    "$WORKER02_HOSTNAME",
    "$LOAD_BALANCER_IP",
    "$MASTER01_IP",
    "$MASTER02_IP",
    "$MASTER03_IP",
    "$WORKER01_IP",
    "$WORKER02_IP",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "$C",
    "L": "$L",
    "O": "$O",
    "OU": "$OU",
    "ST": "$ST"
  }
 ]
}
EOF

# Generate the certificate and private key
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=$MASTER01_HOSTNAME,$MASTER02_HOSTNAME,$MASTER03_HOSTNAME,$LOAD_BALANCER_HOSTNAME,$MASTER01_IP,$MASTER02_IP,$MASTER03_IP,$LOAD_BALANCER_IP,127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

# Verify that the kubernetes-key.pem and the kubernetes.pem file were generated
ls -la
openssl x509 -in kubernetes.pem -text -noout

# Copy certificates to Kubernetes master nodes
for host in ${MASTERS_HOSTS}; do
    sudo sshpass -p $Pi_PASSWORD rsync -r ca.pem kubernetes.pem kubernetes-key.pem $Pi_USERNAME@$host:
done
