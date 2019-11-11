#!/bin/bash

# Source env vars
source ARMadillo/deploy/multi_master/env_vars.sh

for host in ${WORKERS_HOSTS}; do
    sshpass -p $Pi_PASSWORD ssh -o StrictHostKeyChecking=no $Pi_USERNAME@$host 'sudo /sbin/shutdown -hP now'
done

for host in ${MASTERS_HOSTS}; do
    sshpass -p $Pi_PASSWORD ssh -o StrictHostKeyChecking=no $Pi_USERNAME@$host 'sudo /sbin/shutdown -hP now'
done

sshpass -p $Pi_PASSWORD ssh -o StrictHostKeyChecking=no $Pi_USERNAME@$LOAD_BALANCER_HOSTNAME 'sudo /sbin/shutdown -hP now'
