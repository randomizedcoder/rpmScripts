#!/usr/bin/bash

namespace=VLAN4
device=enp1s0f1
vlan=4
ip='10.4.4.10/24'
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

cmd="./configure_namespace_vlan.bash ${namespace} ${device} ${vlan} ${ip} ${bandwidth} ${rtt}"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} ip route add default via 10.4.4.1"
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