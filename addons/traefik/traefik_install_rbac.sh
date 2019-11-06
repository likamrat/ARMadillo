#!/bin/bash



helm install --name traefik --set rbac.enabled=true,serviceType=NodePort,externalIP=172.16.1.14 stable/traefik