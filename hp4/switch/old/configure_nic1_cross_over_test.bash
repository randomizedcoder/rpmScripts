#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root"
	exit 1
fi

device=enp1s0f1
#namespace=NS1
ip="10.0.0.2/24"
bandwidth=8000Mbit
rtt=1ms


cmd="ip addr add ${ip} dev ${device}"
echo "${cmd}"
eval "${cmd}"

cmd="ip link set dev ${device} up"
echo "${cmd}"
eval "${cmd}"

#######
# qdisc

cmd="tc qdisc replace dev ${device} root cake ether-vlan bandwidth ${bandwidth} rtt ${rtt} ack-filter nowash"
echo "${cmd}"
eval "${cmd}"

cmd="tc -s qdisc ls dev ${device}"
echo "${cmd}"
eval "${cmd}"

#######
# sysctls

cmd="sysctl --load ./sysctl.conf"
echo "${cmd}"
eval "${cmd}"

#######
# show

cmd="ip link show"
echo "${cmd}"
eval "${cmd}"

cmd="ip addr show"
echo "${cmd}"
eval "${cmd}"

cmd="ip route show"
echo "${cmd}"
eval "${cmd}"

cmd="ifconfig -a"
echo "${cmd}"
eval "${cmd}"

#####

cmd="netserver"
echo "${cmd}"
eval "${cmd}"

cmd="/usr/local/bin/iperf --server"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep iperf"
echo "${cmd}"
eval "${cmd}"
