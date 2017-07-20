#!/bin/sh
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "${BASE_PATH}/config.sh" ]; then
  echo "${BASE_PATH}/config.sh not found, please copy the config.sh.example and modify."
  exit 1
fi
HA_PROXY_IP=$1

if [ ! ${HA_PROXY_IP} ]; then
  HA_PROXY_IP=`${BASE_PATH}/config.sh HA_PROXY_IP`
fi

SSL_PATH=${BASE_PATH}/ssl
KUBE_APISERVER="https://${HA_PROXY_IP}:6443"
BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')

cat > ${BASE_PATH}/token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

# bootstrap.kubeconfig
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=${SSL_PATH}/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=${BASE_PATH}/bootstrap.kubeconfig
# 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=${BASE_PATH}/bootstrap.kubeconfig
# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=${BASE_PATH}/bootstrap.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=${BASE_PATH}/bootstrap.kubeconfig

#kube-proxy.kubeconfig
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=${SSL_PATH}/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=${BASE_PATH}/kube-proxy.kubeconfig
# 设置客户端认证参数
kubectl config set-credentials kube-proxy \
  --client-certificate=${SSL_PATH}/kube-proxy.pem \
  --client-key=${SSL_PATH}/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=${BASE_PATH}/kube-proxy.kubeconfig
# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=${BASE_PATH}/kube-proxy.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=${BASE_PATH}/kube-proxy.kubeconfig

# ~/.kube/config
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=${SSL_PATH}/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=${BASE_PATH}/config
# 设置客户端认证参数
kubectl config set-credentials admin \
  --certificate-authority=${SSL_PATH}/ca.pem \
  --client-certificate=${SSL_PATH}/admin.pem \
  --embed-certs=true \
  --client-key=${SSL_PATH}/admin-key.pem \
  --kubeconfig=${BASE_PATH}/config
# 设置上下文参数
kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin \
  --kubeconfig=${BASE_PATH}/config
# 设置默认上下文
kubectl config use-context kubernetes --kubeconfig=${BASE_PATH}/config