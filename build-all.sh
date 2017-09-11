#!/bin/bash
BASE_PATH=$(cd `dirname $0`; pwd)
if [ ! -f "$BASE_PATH/config.env" ]; then
  echo "$BASE_PATH/config.env not found, please copy the config.env.example and modify."
  exit 1
else
  . $BASE_PATH/config.env
fi

# build ca
$BASE_PATH/build-ca.sh

# build config
$BASE_PATH/build-config.sh
