#!/bin/sh
BASE_PATH=$(cd `dirname $0`; pwd)
HA_PROXY_IP=$1
SERVERS=$2

if [ ! ${HA_PROXY_IP} ]; then
  HA_PROXY_IP=192.168.10.228
fi
if [ ! ${SERVERS} ]; then
  SERVERS=192.168.10.228,192.168.10.242,192.168.10.243
fi

# clean old config
${BASE_PATH}/clean.sh

# build ca
${BASE_PATH}/build-ca.sh ${SERVERS}

# build config
${BASE_PATH}/build-config.sh ${HA_PROXY_IP}

cd ${BASE_PATH}
# copy setting to master
cp -r ssl ./master/
rm ./master/ssl/*.json
mv config token.csv ./master/

# copy setting to node
cp -r ssl ./node/
rm ./node/ssl/*.json
mv *.kubeconfig ./node/