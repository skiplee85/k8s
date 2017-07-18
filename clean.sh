#!/bin/sh
if [ ! $BASE_PATH ]; then
  BASE_PATH=$(cd `dirname $0`; pwd)
fi

cd $BASE_PATH
rm -rf config *.kubeconfig token.csv ssl/*.pem ssl/*.csr