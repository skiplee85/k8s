#!/bin/sh
kubelet \
  --address=$INTERNAL_IP \
  --hostname-override=$INTERNAL_IP \
  --allow-privileged=true \
  --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0 \
  --cluster-dns=$DNS_SERVER_IP \
  --bootstrap-kubeconfig=$KUBE_PATH/bootstrap.kubeconfig \
  --kubeconfig=$KUBE_PATH/kubelet.kubeconfig \
  --require-kubeconfig=true \
  --cert-dir=$KUBE_PATH/ssl \
  --cluster-domain=$DNS_DOMAIN \
  --serialize-image-pulls=false
