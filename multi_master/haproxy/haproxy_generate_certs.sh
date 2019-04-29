#!/bin/bash

# Source env vars
source env_vars.sh

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
