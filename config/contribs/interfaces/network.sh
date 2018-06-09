#!/bin/sh

/sbin/ip link set eth1 up
/sbin/ip addr add 192.168.57.2/24 broadcast 192.168.57.255 scope global dev eth1
/sbin/ip route add 192.168.57.0/24 proto kernel scope link metric 202 dev eth1 src 192.168.57.2
/sbin/ip route add default via 192.168.57.1 src 192.168.57.2 metric 202 dev eth1
