#!/bin/bash

# Source env vars
source ARMadillo/deploy/multi_master/env_vars.sh

for host in ${MASTERS_HOSTS} && ${WORKERS_HOSTS}; do
    sudo sshpass -p $Pi_PASSWORD ssh -o StrictHostKeyChecking=no $Pi_USERNAME@$host 'sudo /sbin/shutdown -hP now'
done
