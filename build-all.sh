#!/bin/sh
# set INTERNAL_IP & ETCD_SERVERS to master server
# export INTERNAL_IP=192.168.10.228
# export ETCD_SERVERS=https://192.168.10.228:2379,https://192.168.10.242:2379,https://192.168.10.243:2379
# 
BASE_PATH=$(cd `dirname $0`; pwd)
SERVER_IP=192.168.10.228
SERVERS=192.168.10.228,192.168.10.242,192.168.10.243

# clean old config
cd ${BASE_PATH}
rm -rf config *.kubeconfig token.csv ssl/*.pem ssl/*.csr

# build ca
${BASE_PATH}/build-ca.sh ${SERVERS}

# build config
${BASE_PATH}/build-config.sh

cd ${BASE_PATH}
# copy setting to master
cp -r ssl ./master/
rm ./master/ssl/*.json
cp config token.csv ./master/

# copy setting to node
cp -r ssl ./node/
rm ./node/ssl/*.json
cp *.kubeconfig ./node/