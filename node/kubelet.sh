#!/bin/sh
kubelet \
  --address=${INTERNAL_IP} \
  --api-servers=http://${INTERNAL_IP}:8080 \
  --pod-infra-container-image=sz-pg-oam-docker-hub-001.tendcloud.com/library/pod-infrastructure:rhel7 \
  --cgroup-driver=systemd \
  --cluster-dns=10.254.0.2 \
  --experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig \
  --require-kubeconfig \
  --cert-dir=/etc/kubernetes/ssl \
  --cluster-domain=cluster.local. \
  --serialize-image-pulls=false
