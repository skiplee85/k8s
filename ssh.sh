#!/bin/sh
name=$1
ip=$2
ETCD_SERVERS=$3
CLUSTER_LIST=$4

if [ ! $BASE_PATH ]; then
  BASE_PATH=$(cd `dirname $0`; pwd)
fi
KUBE_PATH=/etc/kubernetes
# sed -i s/${ETCD_NAME}/$ETCD/
# ~/.kube/config
# 设置集群参数
ssh root@${ip} mkdir -p ${KUBE_PATH}/log
scp -r $BASE_PATH/master/* root@${ip}:${KUBE_PATH}/

#kubectl config
ssh root@${ip} mkdir -p /root/.kube/
ssh root@${ip} mv ${KUBE_PATH}/config /root/.kube/

#etcd config
ssh root@${ip} sed -i "s/\\\${ETCD_NAME}/${name}/g" ${KUBE_PATH}/etcd/start.sh
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/etcd/start.sh
ssh root@${ip} sed -i "s/\\\${CLUSTER_LIST}/${CLUSTER_LIST}/g" ${KUBE_PATH}/etcd/start.sh

#kube-apiserver config
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/kube-apiserver.sh
ssh root@${ip} sed -i "s/\\\${ETCD_SERVERS}/${ETCD_SERVERS}/g" ${KUBE_PATH}/kube-apiserver.sh

#kube-controller-manager config
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/kube-controller-manager.sh

#kube-scheduler config
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/kube-scheduler.sh

#supervisor config
ssh root@${ip} sed -i "s/\\\${ETCD_NAME}/${name}/g" ${KUBE_PATH}/supervisord.d/kube-server.conf
ssh root@${ip} sed -i "s/\\\${ETCD_SERVERS}/${ETCD_SERVERS}/g" ${KUBE_PATH}/supervisord.d/kube-server.conf
ssh root@${ip} sed -i "s/\\\${CLUSTER_LIST}/${CLUSTER_LIST}/g" ${KUBE_PATH}/supervisord.d/kube-server.conf
ssh root@${ip} sed -i "s/\\\${INTERNAL_IP}/${ip}/g" ${KUBE_PATH}/supervisord.d/kube-server.conf