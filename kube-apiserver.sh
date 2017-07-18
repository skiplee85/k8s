#!/bin/sh
kube-apiserver \
  --advertise-address=${INTERNAL_IP} \
  --bind-address=${INTERNAL_IP} \
  --insecure-bind-address=${INTERNAL_IP} \
  --etcd-servers=${ETCD_SERVERS} \
  --service-cluster-ip-range=10.254.0.0/16 \
  --admission-control=ServiceAccount,NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota \
  --authorization-mode=RBAC \
  --runtime-config=rbac.authorization.k8s.io/v1beta1 \
  --kubelet-https=true \
  --anonymous-auth=false \
  --experimental-bootstrap-token-auth \
  --token-auth-file=/etc/kubernetes/token.csv \
  --service-node-port-range=30000-32767 \
  --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  --client-ca-file=/etc/kubernetes/ssl/ca.pem \
  --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem \
  --etcd-cafile=/etc/kubernetes/ssl/ca.pem \
  --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem \
  --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \
  --enable-swagger-ui=true \
  --apiserver-count=3 \
  --audit-log-maxage=30 \
  --audit-log-maxbackup=3 \
  --audit-log-maxsize=100 \
  --audit-log-path=/var/lib/audit.log \
  --event-ttl=1h