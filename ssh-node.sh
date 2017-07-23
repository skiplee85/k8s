#!/bin/sh
BASE_PATH=$(cd `dirname $0`; pwd)

ip=$1
ETCD_SERVERS=$2

KUBE_PATH=/etc/kubernetes

# ~/.kube/config
# 设置集群参数
ssh root@${ip} mkdir -p ${KUBE_PATH}/log
scp -r $BASE_PATH/node/* root@${ip}:${KUBE_PATH}/

#kubectl config
ssh root@${ip} mkdir -p /root/.kube/
ssh root@${ip} mv ${KUBE_PATH}/config /root/.kube/

#flannel config
ssh root@${ip} sed -i "s/\\\${ETCD_SERVERS}/${ETCD_SERVERS}/g" ${KUBE_PATH}/flannel/start.sh

#kubelet config
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/kubelet.sh

#kube-proxy config
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/kube-proxy.sh

#supervisor config
ssh root@${ip} sed -i "s/\\\${ETCD_SERVERS}/${ETCD_SERVERS}/g" ${KUBE_PATH}/supervisord.d/kube-node.conf
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/supervisord.d/kube-node.conf