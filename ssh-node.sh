#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "${BASE_PATH}/config.env" ]; then
  echo "${BASE_PATH}/config.env not found, please copy the config.env.example and modify."
  exit 1
else
  . ${BASE_PATH}/config.env
fi

INTERNAL_IP=$1
env_replace() {
  file_path=$1
  ssh root@${INTERNAL_IP} sed -i "s/\\\${ETCD_NAME}/${ETCD_NAME}/g" ${file_path}
  ssh root@${INTERNAL_IP} sed -i "s/\\\${INTERNAL_IP}/${INTERNAL_IP}/g" ${file_path}
  ssh root@${INTERNAL_IP} sed -i "s/\\\${KUBE_PATH}/${KUBE_PATH//\//\\\\\/}/g" ${file_path}
  ssh root@${INTERNAL_IP} sed -i "s/\\\${HA_PROXY_IP}/${HA_PROXY_IP}/g" ${file_path}
  ssh root@${INTERNAL_IP} sed -i "s/\\\${ETCD_SERVERS}/${ETCD_SERVERS//\//\\\\\/}/g" ${file_path}
}

# ~/.kube/config
# 设置集群参数
ssh root@${INTERNAL_IP} mkdir -p ${KUBE_PATH}/log
scp -r $BASE_PATH/node/* root@${ip}:${KUBE_PATH}/

#kubectl config
ssh root@${INTERNAL_IP} mkdir -p /root/.kube/
ssh root@${INTERNAL_IP} mv ${KUBE_PATH}/config /root/.kube/

#flannel config
env_replace ${KUBE_PATH}/flannel/start.sh

#kubelet config
env_replace ${KUBE_PATH}/kubelet.sh

#kube-proxy config
env_replace ${KUBE_PATH}/kube-proxy.sh

#supervisor config
env_replace ${KUBE_PATH}/supervisord.d/kube-node.conf