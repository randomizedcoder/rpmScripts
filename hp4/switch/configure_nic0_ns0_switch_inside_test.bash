#!/usr/bin/bash

namespace=NS0
device=enp1s0f0
vlan=2
ip='172.16.50.4/24'
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

#end