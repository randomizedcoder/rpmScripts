#!/usr/bin/bash

cmd="ip netns exec VLAN3 /home/das/networkqualityd --enable-prom --listen-addr 0.0.0.0 --create-cert --public-name 10.3.3.10"
echo "${cmd}"
eval "${cmd}" &