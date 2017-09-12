#!/bin/sh
kube-scheduler --leader-elect=true --address=127.0.0.1 --master=http://127.0.0.1:8080
