#!/bin/sh
kube-scheduler --leader-elect=true --address=127.0.0.1 --master=http://${INTERNAL_IP}:8080
