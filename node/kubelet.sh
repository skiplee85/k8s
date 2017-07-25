#!/bin/sh
kubelet \
  --address=${INTERNAL_IP} \
  --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0 \
  --cluster-dns=10.254.0.2 \
  --experimental-bootstrap-kubeconfig=${KUBE_PATH}/bootstrap.kubeconfig \
  --kubeconfig=${KUBE_PATH}/kubelet.kubeconfig \
  --require-kubeconfig=true \
  --cert-dir=${KUBE_PATH}/ssl \
  --cluster-domain=cluster.local. \
  --serialize-image-pulls=false
