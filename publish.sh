#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "${BASE_PATH}/config.env" ]; then
  echo "${BASE_PATH}/config.env not found, please copy the config.env.example and modify."
  exit 1
else
  . ${BASE_PATH}/config.env
fi

usage() {
        echo "$0  [-b] [-a] [-m] [-n]

Publish setting to masters or nodes
OPTIONS:
        -b      Use config.env and ssl to build settings
        -a      Publish all (include masters and nodes)
        -m      Publish to masters
        -n      Publish to nodes
" >&2

        exit 1
}

masters_publish() {
  for server in ${MASTERS[@]}  
  do
    echo $server
    name=`echo $server | cut -d : -f 1`
    ip=`echo $server | cut -d : -f 2`
    ${BASE_PATH}/ssh-master.sh $name $ip
  done
}

nodes_publish() {
  for node in ${NODES[@]}  
  do
    echo $node
    ${BASE_PATH}/ssh-node.sh $node
  done
}

while getopts "abmn?h" opt; do
  case $opt in
    a)
      masters_publish
      nodes_publish
      ;;
    b)
      ${BASE_PATH}/build-all.sh
      ;;
    m)
      masters_publish
      ;;
    n)
      nodes_publish
      ;;
    [\?h])
      usage
      ;;
  esac
done