#!/bin/sh
if [ ! $1 ]; then
  echo "Servers IP is null!"
  exit 1
fi

BASE_PATH=$(cd `dirname $0`; pwd)

cd ${BASE_PATH}/ssl

# ca.csr ca.pem ca-key.pem
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# kubernetes.csr kubernetes-key.pem kubernetes.pem
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
  -hostname="$1,127.0.0.1,10.254.0.1,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local" \
  kubernetes-csr.json | cfssljson -bare kubernetes

# admin.csr admin-key.pem admin.pem
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin

# kube-proxy.csr kube-proxy-key.pem kube-proxy.pem
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy