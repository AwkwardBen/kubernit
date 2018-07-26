#!/bin/sh
# inputs include:
# - init/join - if this is an init pocess or joining another kubelet
# on init here's the arguments
# - master/worker - if master then taint kept unless slave then untainted
# - pod cidr - the subnet for pod e.g. 10.244.0.0/16
# - service cidr - the subnet for services e.g. 10.200.0.0/16
# on join here's the argument
# - endpoint - the endpoint of the joining kubernetes cluster
# - token - the token to join this cluster
# - ca - the sha256 of the ca of this cluster

set -e
touch /var/lib/kubeadm/.kubeadm-init.sh-started

for opt in $(cat /proc/cmdline); do
	case "$opt" in
	ipAddress=*)
		fullAddress=${opt#ipAddress=}
		ip=${fullAddress%,*}
		;;
	esac
done

if [ "$1" == "init" ]; then
	if [ -f /etc/kubeadm/kubeadm.yaml ]; then
    echo Using the configuration from /etc/kubeadm/kubeadm.yaml
    if [ $# -ne 0 ] ; then
        echo WARNING: Ignoring command line options: $@
    fi
    kubeadm init --ignore-preflight-errors=all --config /etc/kubeadm/kubeadm.yaml
	else
    kubeadm init --apiserver-advertise-address=$ip \
    --ignore-preflight-errors=all \
    --cri-socket=/run/containerd/containerd.sock \
    --kubernetes-version=@KUBERNETES_VERSION@ \
    --pod-network-cidr=$3 \
    --service-cidr=$4 $@
	fi
elif [ "$1" == "join" ]; then
		kubeadm join $2 \
		--token $3
		--discovery-token-ca-cert-hash $4 \
		--ignore-preflight-errors=all \
		--cri-socket=/run/containerd/containerd.sock
else
	echo "Bad arguments, no match to init or join"
	exit 1
fi
# sorting by basename relies on the dirnames having the same number of directories
YAML=$(ls -1 /run/config/kube-system.init/*.yaml /etc/kubeadm/kube-system.init/*.yaml 2>/dev/null | sort --field-separator=/ --key=5)
for i in ${YAML}; do
    n=$(basename "$i")
    if [ -e "$i" ] ; then
	    if [ ! -s "$i" ] ; then # ignore zero sized files
	      echo "Ignoring zero size file $n"
	      continue
	    fi
	    echo "Applying $n"
	    if ! kubectl create -n kube-system -f "$i" ; then
	      touch /var/lib/kubeadm/.kubeadm-init.sh-kube-system.init-failed
	      touch /var/lib/kubeadm/.kubeadm-init.sh-kube-system.init-"$n"-failed
	      echo "Failed to apply $n"
	      continue
	    fi
    fi
done
if [ "$2" == "worker" ] ; then
    echo "Removing \"node-role.kubernetes.io/master\" taint from all nodes"
    kubectl taint nodes --all node-role.kubernetes.io/master-
fi
touch /var/lib/kubeadm/.kubeadm-init.sh-finished
