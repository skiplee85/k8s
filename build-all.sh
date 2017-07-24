#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "${BASE_PATH}/config.env" ]; then
  echo "${BASE_PATH}/config.env not found, please copy the config.env.example and modify."
  exit 1
else
  . ${BASE_PATH}/config.env
fi

# clean old config
${BASE_PATH}/clean.sh

# build ca
${BASE_PATH}/build-ca.sh

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
cp config ./node/
mv *.kubeconfig ./node/