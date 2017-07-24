#!/bin/sh
kube-proxy \
  --bind-address=${INTERNAL_IP} \
  --hostname-override=${INTERNAL_IP} \
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \
  --cluster-cidr=10.254.0.0/16
