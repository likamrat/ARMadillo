#!/bin/bash

sudo cat <<EOT >> ARMadillo/addons/helm/tiller-rbac.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOT


helm init --tiller-image=jessestuart/tiller --history-max 200 --upgrade
kubectl apply -f ARMadillo/addons/helm/tiller-rbac.yaml
helm init --tiller-image=jessestuart/tiller --service-account tiller
