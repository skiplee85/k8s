#!/bin/sh
flanneld \
  -etcd-endpoints=${ETCD_SERVERS} \
  -etcd-cafile=/etc/kubernetes/ssl/ca.pem \
  -etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem \
  -etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \
  -subnet-file=/etc/kubernetes/flannel/subnet.env