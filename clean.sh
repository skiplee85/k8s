#!/bin/sh
BASE_PATH=$(cd `dirname $0`; pwd)

cd $BASE_PATH
rm -rf *.kubeconfig config ssl/*.pem ssl/*.csr token.csv\
  master/ssl master/config master/token.csv \
  node/ssl node/config node/*.kubeconfig
