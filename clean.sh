#!/bin/sh
if [ ! $BASE_PATH ]; then
  BASE_PATH=$(cd `dirname $0`; pwd)
fi

cd $BASE_PATH
rm -rf ssl/*.pem ssl/*.csr master/ssl master/config master/token.csv node/ssl node/*.kubeconfig