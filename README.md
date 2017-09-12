# Kubernetes setting shell

## Require

- [cfssl](https://github.com/cloudflare/cfssl)
- [kubernetes](https://github.com/kubernetes/kubernetes)
- [etcd](https://github.com/coreos/etcd)
- [flannel](https://github.com/coreos/flannel)
- [supervisor (optional)](https://github.com/Supervisor/supervisor)

## Setting

### Step 1

Update *config.env* setting.

- KUBE_PATH
- HA_PROXY_IP
- MASTERS
- NODES
- BOOTSTRAP_TOKEN
- P12_PASSWORD

You can copy from *config.env.example*.

```sh
cp config.env.example config.env
# BOOTSTRAP_TOKEN
head -c 16 /dev/urandom | od -An -t x | tr -d ' '
```

### Step 2

Download require software and link to bin path.

#### Master

- etcd
- kube-apiserver
- kube-controller-manager
- kube-scheduler

#### Node

- flannel
- docker
- kubelet
- kube-proxy

```sh
# master
# etcd
ln -s /opt/etcd-v3.2.2-linux-amd64/etcd /usr/local/bin/
ln -s /opt/etcd-v3.2.2-linux-amd64/etcdctl /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kube-apiserver /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kube-controller-manager /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kube-scheduler /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kubectl /usr/local/bin/

# node
ln -s /opt/flanneld /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kubelet /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kube-proxy /usr/local/bin/
ln -s /opt/kubernetes/server/bin/kubectl /usr/local/bin/
```

### Step 3

Publish setting. (The masters & nodes need to set SSH first.)

```sh
./publish.sh -b -a
```

### Step 4

#### Master start

```sh
# etcd
/etc/kubernetes/etcd/start.sh

# apiserver
/etc/kubernetes/etcd/kube-apiserver.sh

# controller-manager
/etc/kubernetes/etcd/kube-controller-manager.sh

# scheduler
/etc/kubernetes/etcd/kube-scheduler.sh

# init-setting. Just only exec once.
/etc/kubernetes/etcd/init-master.sh
```

#### Node start

```sh
# flannel
/etc/kubernetes/flannel/start.sh

# kubelet
/etc/kubernetes/etcd/kubelet.sh

# proxy
/etc/kubernetes/etcd/kube-proxy.sh

# init-setting. Just only exec once.
/etc/kubernetes/init-node.sh

# Approve this node. Just only exec once.
kubectl get csr
# NAME                                                   AGE       REQUESTOR           CONDITION
# node-csr-5WW3f84N09lX2pkWmfvT833gAXW_RZTf-G6N0L-P5Ms   10s       kubelet-bootstrap   Pending
kubectl certificate approve node-csr-xxxxx
```

#### Use supervisor

```sh
cp /etc/kubernetes/supervisord.d/* /etc/supervisor/conf.d/
supervisorctl update

# master
supervisorctl start kube_server:*
# init-setting. Just only exec once.
/etc/kubernetes/init-master.sh

# node
supervisorctl start kube_node:*
# init-setting. Just only exec once.
/etc/kubernetes/init-node.sh
# Approve this node. Just only exec once.
kubectl get csr
# NAME                                                   AGE       REQUESTOR           CONDITION
# node-csr-5WW3f84N09lX2pkWmfvT833gAXW_RZTf-G6N0L-P5Ms   10s       kubelet-bootstrap   Pending
kubectl certificate approve node-csr-xxxxx
```