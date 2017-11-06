#!/bin/sh
flannel_env="$KUBE_PATH/flannel/subnet.env"
docker_conf="/etc/docker/daemon.json"

if [ -f "$flannel_env" ]; then
  . $flannel_env
fi

echo "{\"registry-mirrors\":[\"https:\/\/7kwfkwia.mirror.aliyuncs.com\"],\"iptables\":false" > $docker_conf

if [ -n "$FLANNEL_SUBNET" ]; then
  echo ",\"bip\":\"$FLANNEL_SUBNET\"" >> $docker_conf
fi

if [ -n "$FLANNEL_MTU" ]; then
  echo ",\"mtu\":$FLANNEL_MTU" >> $docker_conf
fi

if [ "$FLANNEL_IPMASQ" = true ] ; then
  echo ",\"ip-masq\":false" >> $docker_conf
elif [ "$FLANNEL_IPMASQ" = false ] ; then
  echo ",\"ip-masq\":true" >> $docker_conf
fi

echo "}" >> $docker_conf

iptables -P FORWARD ACCEPT
service docker restart