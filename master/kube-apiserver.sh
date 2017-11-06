#!/bin/sh
kube-apiserver \
  --advertise-address=$INTERNAL_IP \
  --insecure-bind-address=127.0.0.1 \
  --etcd-servers=$ETCD_SERVERS \
  --allow-privileged=true \
  --service-cluster-ip-range=10.254.0.0/16 \
  --admission-control=ServiceAccount,NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota \
  --authorization-mode=Node,RBAC \
  --runtime-config=rbac.authorization.k8s.io/v1beta1 \
  --kubelet-https=true \
  --enable-bootstrap-token-auth \
  --token-auth-file=$KUBE_PATH/token.csv \
  --service-node-port-range=30000-32767 \
  --tls-cert-file=$KUBE_PATH/ssl/kubernetes.pem \
  --tls-private-key-file=$KUBE_PATH/ssl/kubernetes-key.pem \
  --client-ca-file=$KUBE_PATH/ssl/ca.pem \
  --service-account-key-file=$KUBE_PATH/ssl/ca-key.pem \
  --etcd-cafile=$KUBE_PATH/ssl/ca.pem \
  --etcd-certfile=$KUBE_PATH/ssl/kubernetes.pem \
  --etcd-keyfile=$KUBE_PATH/ssl/kubernetes-key.pem \
  --enable-swagger-ui=true \
  --apiserver-count=3 \
  --audit-log-maxage=30 \
  --audit-log-maxbackup=3 \
  --audit-log-maxsize=100 \
  --audit-log-path=$DATA_PATH/log/audit.log \
  --event-ttl=1h
