#!/bin/sh
etcd \
--name $ETCD_NAME \
--data-dir $KUBE_PATH/etcd/data \
--wal-dir $KUBE_PATH/etcd/wal \
--snapshot-count 10000 \
--heartbeat-interval 100 \
--election-timeout 1000 \
--quota-backend-bytes 0 \
--listen-peer-urls https://$INTERNAL_IP:2380 \
--listen-client-urls https://$INTERNAL_IP:2379,http://127.0.0.1:2379 \
--max-snapshots 5 \
--max-wals 5 \
--initial-advertise-peer-urls https://$INTERNAL_IP:2380 \
--advertise-client-urls https://$INTERNAL_IP:2379 \
--initial-cluster $CLUSTER_LIST \
--initial-cluster-token 'etcd-cluster' \
--initial-cluster-state 'new' \
--strict-reconfig-check=false \
--enable-v2=true \
--proxy 'off' \
--proxy-failure-wait 5000 \
--proxy-refresh-interval 30000 \
--proxy-dial-timeout 1000 \
--proxy-write-timeout 5000 \
--proxy-read-timeout 0 \
--cert-file $KUBE_PATH/ssl/kubernetes.pem \
--key-file $KUBE_PATH/ssl/kubernetes-key.pem \
--client-cert-auth=true \
--trusted-ca-file $KUBE_PATH/ssl/ca.pem \
--auto-tls=false \
--peer-cert-file $KUBE_PATH/ssl/kubernetes.pem \
--peer-key-file $KUBE_PATH/ssl/kubernetes-key.pem \
--peer-client-cert-auth=true \
--peer-trusted-ca-file $KUBE_PATH/ssl/ca.pem \
--peer-auto-tls=false \
--debug=false \
--force-new-cluster=false
# Discovery URL used to bootstrap the cluster.
# --discovery \
# Valid values include 'exit', 'proxy'
# --discovery-fallback 'proxy' \
# HTTP proxy to use for traffic to discovery service.
# --discovery-proxy \
# DNS domain used to bootstrap initial cluster.
# --discovery-srv \
# Specify a particular log level for each etcd package (eg 'etcdmain=CRITICAL,etcdserver=DEBUG'.
# --log-package-levels \
# Force to create a new one member cluster.