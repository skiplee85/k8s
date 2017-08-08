#!/bin/sh
kube-controller-manager \
  --address=127.0.0.1 \
  --service-cluster-ip-range=10.254.0.0/16 \
  --cluster-cidr=10.254.0.0/16 \
  --cluster-name=kubernetes \
  --cluster-signing-cert-file=$KUBE_PATH/ssl/ca.pem \
  --cluster-signing-key-file=$KUBE_PATH/ssl/ca-key.pem \
  --service-account-private-key-file=$KUBE_PATH/ssl/ca-key.pem \
  --root-ca-file=$KUBE_PATH/ssl/ca.pem \
  --leader-elect=true \
  --master=http://$INTERNAL_IP:8080
