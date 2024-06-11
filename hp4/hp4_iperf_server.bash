#!/usr/bin/bash

cmd="/usr/local/bin/iperf --server"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep iperf"
echo "${cmd}"
eval "${cmd}"