#!/bin/sh
flanneld \
  -etcd-endpoints=$ETCD_SERVERS \
  -etcd-cafile=$KUBE_PATH/ssl/ca.pem \
  -etcd-certfile=$KUBE_PATH/ssl/kubernetes.pem \
  -etcd-keyfile=$KUBE_PATH/ssl/kubernetes-key.pem \
  -ip-masq \
  -subnet-file=$KUBE_PATH/flannel/subnet.env