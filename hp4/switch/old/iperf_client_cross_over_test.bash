#!/usr/bin/bash

cmd="/usr/local/bin/iperf -c 10.0.0.1 --interval 1 --time 30 -e -w 4M --tcp-write-prefetch 128K --parallel 20"
echo "${cmd}"
eval "${cmd}"