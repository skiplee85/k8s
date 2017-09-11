#!/bin/sh
BASE_PATH=$(cd `dirname $0`; pwd)

cd $BASE_PATH
rm -rf *.kubeconfig kubectl-config ssl/*.pem ssl/*.csr \
  master/ssl/*.pem master/config master/token.csv \
  node/ssl/*.pem node/config node/*.kubeconfig
