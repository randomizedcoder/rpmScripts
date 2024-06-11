#!/usr/bin/bash

namespace=VLAN5
device=enp1s0f0
vlan=5
ip='172.16.5.10/24'
bandwidth=1000Mbit
rtt=1ms

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

# namespace=$1
# device=$2
# vlan=$3
# ip=$4
# bandwidth=$5
# rtt=$6

cmd="../configure_namespace_vlan.bash ${namespace} ${device} ${vlan} ${ip} ${bandwidth} ${rtt}"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} ip route add 172.16.6.0/24 via 172.16.5.1"
echo_and_run "${cmd}"

#######
# show

cmd="ip netns exec ${namespace} ip link show"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} ip route show"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} ifconfig -a"
echo_and_run "${cmd}"

#end