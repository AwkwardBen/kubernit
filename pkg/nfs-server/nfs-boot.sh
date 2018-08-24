#!/bin/sh -eu

/bin/sleep 100000

/usr/sbin/exportfs -r
/sbin/rpcbind --
/sbin/rpc.statd
#/usr/sbin/rpc.nfsd
/usr/sbin/rpc.mountd -F
