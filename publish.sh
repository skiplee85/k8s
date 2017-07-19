#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
# Master servers, install etcd kube-apiserver kube-controller-manager kube-scheduler
MASTERS=(
  "k8s-master-1:192.168.10.228"
  "k8s-master-2:192.168.10.242"
  "k8s-master-3:192.168.10.243"
)
HA_PROXY_IP=192.168.10.228
SERVERS=""
ETCD_SERVERS=""
CLUSTER_LIST=""
for server in ${MASTERS[@]}  
do
  name=`echo $server | cut -d : -f 1`
  ip=`echo $server | cut -d : -f 2`
  if [ ! ${SERVERS} ]; then
    SERVERS=${ip}
  else
    SERVERS="${SERVERS},${ip}"
  fi
  
  if [ ! ${ETCD_SERVERS} ]; then
    ETCD_SERVERS="https://${ip}:2379"
    CLUSTER_LIST="${name}=https://${ip}:2380"
  else
    ETCD_SERVERS="${ETCD_SERVERS},https://${ip}:2379"
    CLUSTER_LIST="${CLUSTER_LIST},${name}=https://${ip}:2380"
  fi
done

chmod +x ${BASE_PATH}/*.sh

${BASE_PATH}/build-all.sh ${HA_PROXY_IP} ${SERVERS}

for server in ${MASTERS[@]}  
do
  name=`echo $server | cut -d : -f 1`
  ip=`echo $server | cut -d : -f 2`
  ${BASE_PATH}/ssh.sh $name $ip ${ETCD_SERVERS//\//\\\\\/} ${CLUSTER_LIST//\//\\\\\/}
done
