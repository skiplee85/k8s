#!/bin/sh

etcdctl --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mk /coreos.com/network/config '{"Network":"172.17.0.0/16", "SubnetMin":"172.17.1.0", "SubnetMax":"172.17.254.0", "Backend":{"Type":"host-gw"}}'

kubectl create clusterrolebinding kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --user=kubelet-bootstrap