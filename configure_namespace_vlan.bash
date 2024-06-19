#!/usr/bin/bash

# https://www.man7.org/linux/man-pages/man8/ip-netns.8.html
# $ ip netns pids net0 | xargs kill
# $ ip netns del net0
# ip netns identify [PID]
# ip netns pids NAME


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

namespace=$1
device=$2
vlan=$3
ip=$4
bandwidth=$5
rtt=$6

echo "### configure_namespace_vlan.bash"
echo "namespace:${namespace}"
echo "device:${device}"
echo "vlan:${vlan}"
echo "ip:${ip}"
echo "bandwidth:${bandwidth}"
echo "rtt:${rtt}"

echo "### Delete network namespace:${namespace}"
cmd="ip netns del ${namespace}"
echo_and_run "${cmd}"

echo "### Creating network namespace:${namespace}"
cmd="ip netns add ${namespace}"
echo_and_run "${cmd}"

echo "### Creating vlan interface"
cmd="ip link add link ${device} name ${device}.${vlan} type vlan id ${vlan}"
echo_and_run "${cmd}"

echo "### Moving vlan interface to network namespace"
cmd="ip link set dev ${device}.${vlan} netns ${namespace}"
echo_and_run "${cmd}"

echo "### Configure IP address"
cmd="ip netns exec ${namespace} ip addr add ${ip} dev ${device}.${vlan}"
echo_and_run "${cmd}"

echo "### View IP address"
cmd="ip netns exec ${namespace} ip addr show"
echo_and_run "${cmd}"

#######
# qdisc

echo "### Configure qdisc CAKE"
cmd="ip netns exec ${namespace} tc qdisc replace dev ${device}.${vlan} root cake ether-vlan bandwidth ${bandwidth} rtt ${rtt} ack-filter nowash"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} tc -s qdisc ls dev ${device}.${vlan}"
echo_and_run "${cmd}"

# tc -p -s -d qdisc show dev eth2
# tc -d class show dev eth2

cmd="ip netns exec ${namespace} tc -d class show dev ${device}.${vlan}"
echo_and_run "${cmd}"

#######
# sysctls

cmd="ip netns exec ${namespace} sysctl --load ./sysctl.conf"
echo_and_run "${cmd}"

#######
# Up

echo "### Bring namespace loopback interface up"
cmd="ip netns exec ${namespace} ip link set lo up"
echo_and_run "${cmd}"

echo "### Bring interface up"
cmd="ip netns exec ${namespace} ip link set dev ${device}.${vlan} up"
echo_and_run "${cmd}"

#######
# sleep

echo "### Sleep 1 - to allow interface to com up"
sleep 1

#######
# show

cmd="ip netns exec ${namespace} ip link show"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} ip route show"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} ifconfig -a"
echo_and_run "${cmd}"

#####

cmd="ip netns exec ${namespace} netserver"
echo_and_run "${cmd}"

cmd="ip netns exec ${namespace} /usr/local/bin/iperf --server"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep iperf"
echo_and_run "${cmd}"

# end