#!/usr/bin/bash

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

namespace=VLAN4
ip="10.3.3.10"

cmd="ip netns exec ${namespace} /home/das/goresponsiveness/networkQuality \
    --url http://${ip}:4043/.well-known/nq \
    --insecure-skip-verify \
    --extended-stats \
    --relative-rpm \
    --quality-attenuation"

echo_and_run "${cmd}"

# end