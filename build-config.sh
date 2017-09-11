#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "$BASE_PATH/config.env" ]; then
  echo "$BASE_PATH/config.env not found, please copy the config.env.example and modify."
  exit 1
else
  . $BASE_PATH/config.env
fi

SSL_PATH=$BASE_PATH/ssl
KUBE_APISERVER="https://$HA_PROXY_IP:6443"

cat > $BASE_PATH/master/token.csv <<EOF
$BOOTSTRAP_TOKEN,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

# bootstrap.kubeconfig
# set-cluster
kubectl config set-cluster kubernetes \
  --certificate-authority=$SSL_PATH/ca.pem \
  --embed-certs=true \
  --server=$KUBE_APISERVER \
  --kubeconfig=$BASE_PATH/node/bootstrap.kubeconfig
# set-credentials
kubectl config set-credentials kubelet-bootstrap \
  --token=$BOOTSTRAP_TOKEN \
  --kubeconfig=$BASE_PATH/node/bootstrap.kubeconfig
# set-context
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=$BASE_PATH/node/bootstrap.kubeconfig
# use-context
kubectl config use-context default --kubeconfig=$BASE_PATH/node/bootstrap.kubeconfig

#kube-proxy.kubeconfig
# set-cluster
kubectl config set-cluster kubernetes \
  --certificate-authority=$SSL_PATH/ca.pem \
  --embed-certs=true \
  --server=$KUBE_APISERVER \
  --kubeconfig=$BASE_PATH/node/kube-proxy.kubeconfig
# set-credentials
kubectl config set-credentials kube-proxy \
  --client-certificate=$SSL_PATH/kube-proxy.pem \
  --client-key=$SSL_PATH/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=$BASE_PATH/node/kube-proxy.kubeconfig
# set-context
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=$BASE_PATH/node/kube-proxy.kubeconfig
# use-context
kubectl config use-context default --kubeconfig=$BASE_PATH/node/kube-proxy.kubeconfig

# ~/.kube/config
# set-cluster
kubectl config set-cluster kubernetes \
  --certificate-authority=$SSL_PATH/ca.pem \
  --embed-certs=true \
  --server=$KUBE_APISERVER \
  --kubeconfig=$BASE_PATH/kubectl-config
# set-credentials
kubectl config set-credentials admin \
  --certificate-authority=$SSL_PATH/ca.pem \
  --client-certificate=$SSL_PATH/admin.pem \
  --embed-certs=true \
  --client-key=$SSL_PATH/admin-key.pem \
  --kubeconfig=$BASE_PATH/kubectl-config
# set-context
kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin \
  --kubeconfig=$BASE_PATH/kubectl-config
# use-context
kubectl config use-context kubernetes --kubeconfig=$BASE_PATH/kubectl-config

# copy setting to master
cp $BASE_PATH/kubectl-config $BASE_PATH/master/config

# copy setting to node
cp $BASE_PATH/kubectl-config $BASE_PATH/node/config
