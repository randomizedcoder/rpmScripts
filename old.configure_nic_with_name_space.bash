#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root"
	exit 1
fi

device=$1
namespace=$2
ip=$3
bandwidth=$4
rtt=$5

echo "device:${device}"
echo "namespace:${namespace}"
echo "ip:${ip}"
echo "bandwidth:${bandwidth}"
echo "rtt:${rtt}"

echo "### Creating network namespace:${namespace}"
cmd="ip netns add ${namespace}"
echo "${cmd}"
eval "${cmd}"

cmd="ip link set dev ${device} netns ${namespace}"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} ip addr add ${ip} dev ${device}"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} ip link set dev ${device} up"
echo "${cmd}"
eval "${cmd}"

#######
# qdisc

cmd="ip netns exec ${namespace} tc qdisc replace dev ${device} root cake ether-vlan bandwidth ${bandwidth} rtt ${rtt} ack-filter nowash"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} tc -s qdisc ls dev ${device}"
echo "${cmd}"
eval "${cmd}"

#######
# sysctls

cmd="ip netns exec ${namespace} sysctl --load ./sysctl.conf"
echo "${cmd}"
eval "${cmd}"

#######
# show

cmd="ip netns exec ${namespace} ip link show"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} ip addr show"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} ip route show"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} ifconfig -a"
echo "${cmd}"
eval "${cmd}"

#####

cmd="ip netns exec ${namespace} netserver"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec ${namespace} /usr/local/bin/iperf --server"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep iperf"
echo "${cmd}"
eval "${cmd}"
