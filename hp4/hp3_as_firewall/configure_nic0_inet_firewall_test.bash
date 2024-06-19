#!/usr/bin/bash

namespace=VLAN3
device=enp1s0f0
vlan=3
ip="10.3.3.10/24"
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

cmd="ip netns exec ${namespace} ip route add default via 10.3.3.1"
echo_and_run "${cmd}"

cmd="ip netns exec INET /home/das/networkqualityd --enable-prom --listen-addr 0.0.0.0 --create-cert --public-name 10.3.3.10"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep networkqualityd"
echo_and_run "${cmd}"

#end