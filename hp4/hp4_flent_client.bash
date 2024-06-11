#!/usr/bin/bash

ip="76.174.138.10"
device=enp1s0f1
bandwidth=1000Mbit
rtt=3ms

#######
# qdisc

cmd="ip netns exec tc qdisc replace dev ${device} root cake ether-vlan bandwidth ${bandwidth} rtt ${rtt} ack-filter nowash"
echo "${cmd}"
eval "${cmd}"

cmd="ip netns exec tc -s qdisc ls dev ${device}"
echo "${cmd}"
eval "${cmd}"

cmd="flent rrul --host ${ip} --socket-stats --verbose --length 3600"
echo "${cmd}"
eval "${cmd}"