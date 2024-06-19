#!/usr/bin/bash

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root"
	exit 1
fi

cmd="ethtool --set-ring enp1s0f0 rx 8192 tx 8192"
echo_and_run "${cmd}"

cmd="ethtool --set-ring enp1s0f1 rx 8192 tx 8192"
echo_and_run "${cmd}"

# end