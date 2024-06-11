#!/usr/bin/bash

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

namespace=INSIDE
ip="172.16.50.4"

cmd="ip netns exec ${namespace} /usr/local/bin/iperf -c ${ip} --interval 1 --time 30 -e -w 8M --tcp-write-prefetch 128K --parallel 20"
echo_and_run "${cmd}"

# end