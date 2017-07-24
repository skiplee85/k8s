#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "${BASE_PATH}/config.env" ]; then
  echo "${BASE_PATH}/config.env not found, please copy the config.env.example and modify."
  exit 1
else
  . ${BASE_PATH}/config.env
fi

${BASE_PATH}/clean.sh
${BASE_PATH}/build-all.sh

for server in ${MASTERS[@]}  
do
  echo $server
  name=`echo $server | cut -d : -f 1`
  ip=`echo $server | cut -d : -f 2`
  ${BASE_PATH}/ssh-master.sh $name $ip ${ETCD_SERVERS//\//\\\\\/} ${CLUSTER_LIST//\//\\\\\/}
done

for node in ${NODES[@]}  
do
  echo $node
  ${BASE_PATH}/ssh-node.sh $node ${ETCD_SERVERS//\//\\\\\/}
done
