#!/usr/bin/bash

device=enp1s0f1
vlan=4
ip="10.4.4.1/24"
bandwidth=1000Mbi
rtt=1ms

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

echo "### configure_nic1_inet_firewall_test.bash"
echo "device:${device}"
echo "vlan:${vlan}"
echo "ip:${ip}"
echo "bandwidth:${bandwidth}"
echo "rtt:${rtt}"

echo "### Creating vlan interface"
cmd="ip link add link ${device} name ${device}.${vlan} type vlan id ${vlan}"
echo_and_run "${cmd}"

echo "### Configure IP address"
cmd="ip addr add ${ip} dev ${device}.${vlan}"
echo_and_run "${cmd}"

echo "### View IP address"
cmd="ip addr show"
echo_and_run "${cmd}"

#######
# qdisc

echo "### Configure qdisc CAKE"
cmd="tc qdisc replace dev ${device}.${vlan} root cake ether-vlan bandwidth ${bandwidth} rtt ${rtt} ack-filter nowash"
echo_and_run "${cmd}"

cmd="tc -s qdisc ls dev ${device}.${vlan}"
echo_and_run "${cmd}"

# tc -p -s -d qdisc show dev eth2
# tc -d class show dev eth2

cmd="tc -d class show dev ${device}.${vlan}"
echo_and_run "${cmd}"

#######
# sysctls

cmd="sysctl --load ./sysctl.conf"
echo_and_run "${cmd}"

#######
# Up

# echo "### Bring namespace loopback interface up"
# cmd="ip netns exec ${namespace} ip link set lo up"
# echo_and_run "${cmd}"

echo "### Bring interface up"
cmd="ip link set dev ${device} up"
echo_and_run "${cmd}"

echo "### Bring vlan interface up"
cmd="ip link set dev ${device}.${vlan} up"
echo_and_run "${cmd}"

#######
# sleep

echo "### Sleep 1 - to allow interface to come up"
sleep 1

#######
# show

cmd="ip link show"
echo_and_run "${cmd}"

cmd="ip route show"
echo_and_run "${cmd}"

cmd="ifconfig -a"
echo_and_run "${cmd}"

#####

cmd="netserver"
echo_and_run "${cmd}"

cmd="/usr/local/bin/iperf --server"
echo "${cmd}"
eval "${cmd}" &

cmd="ps ax | grep iperf"
echo_and_run "${cmd}"

#end