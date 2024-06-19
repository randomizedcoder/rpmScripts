#!/usr/bin/bash

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

namespace=INSIDE
ip="76.174.30.5"

cmd="ip netns exec ${namespace} /home/das/goresponsiveness/networkQuality \
    --url http://${ip}:4043/.well-known/nq \
    --insecure-skip-verify \
    --extended-stats \
    --relative-rpm \
    --quality-attenuation"

echo_and_run "${cmd}"

# end