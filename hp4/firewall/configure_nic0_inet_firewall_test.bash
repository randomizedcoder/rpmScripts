#!/usr/bin/bash

namespace=INET
device=enp1s0f0
vlan=10
ip="76.174.30.5/20"
bandwidth=1000Mbi
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

cmd="ip netns exec INET /home/das/networkqualityd --enable-prom --listen-addr 0.0.0.0 --create-cert --public-name 76.174.30.5"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep networkqualityd"
echo_and_run "${cmd}"

#end