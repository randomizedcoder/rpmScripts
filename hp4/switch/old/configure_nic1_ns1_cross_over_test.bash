#!/usr/bin/bash

device=enp1s0f1
namespace=NS1
ip="10.0.0.2/24"
bandwidth=8000Mbit
rtt=1ms

cmd="./configure_nic_with_name_space.bash ${device} ${namespace} ${ip} ${bandwidth} ${rtt}"
echo "${cmd}"
eval "${cmd}"