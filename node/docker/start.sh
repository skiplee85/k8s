#!/bin/bash
$KUBE_PATH/docker/build-conf.sh && dockerd --config-file=$KUBE_PATH/docker/daemon.json