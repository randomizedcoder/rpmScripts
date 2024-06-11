#!/usr/bin/bash

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

namespace=INSIDE
ip="76.174.138.10"

cmd="ip netns exec ${namespace} flent rrul --host ${ip} --socket-stats --verbose --length 600"
echo_and_run "${cmd}"

# end