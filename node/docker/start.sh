#!/bin/bash
/etc/kubernetes/docker/build-conf.sh \
  && dockerd --config-file=/etc/kubernetes/docker/daemon.json