#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "${BASE_PATH}/config.sh" ]; then
  echo "${BASE_PATH}/config.sh not found, please copy the config.sh.example and modify."
  exit 1
fi

MASTERS=`${BASE_PATH}/config.sh MASTERS`
ETCD_SERVERS=`${BASE_PATH}/config.sh ETCD_SERVERS`
CLUSTER_LIST=`${BASE_PATH}/config.sh CLUSTER_LIST`

${BASE_PATH}/clean.sh
${BASE_PATH}/build-all.sh

MASTERS_ARR=(${MASTERS//,/ })
for server in ${MASTERS_ARR[@]}  
do
  echo $server
  name=`echo $server | cut -d : -f 1`
  ip=`echo $server | cut -d : -f 2`
  ${BASE_PATH}/ssh-master.sh $name $ip ${ETCD_SERVERS//\//\\\\\/} ${CLUSTER_LIST//\//\\\\\/}
done

NODES_ARR=(${NODES//,/ })
for node in ${NODES_ARR[@]}  
do
  echo $node
  ${BASE_PATH}/ssh-node.sh $node ${ETCD_SERVERS//\//\\\\\/}
done
