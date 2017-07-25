#!/bin/sh
kube-proxy \
  --bind-address=${INTERNAL_IP} \
  --hostname-override=${INTERNAL_IP} \
  --kubeconfig=${KUBE_PATH}/kube-proxy.kubeconfig \
  --cluster-cidr=10.254.0.0/16
