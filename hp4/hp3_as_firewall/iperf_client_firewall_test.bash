#!/usr/bin/bash

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

namespace=VLAN4
ip="10.3.3.10"
p=$1
i=$2

cmd="ip netns exec ${namespace} /usr/local/bin/iperf -c ${ip} --interval ${i} --time 30 -e -w 8M --tcp-write-prefetch 128K --parallel ${p} --reverse"
echo_and_run "${cmd}"

# end