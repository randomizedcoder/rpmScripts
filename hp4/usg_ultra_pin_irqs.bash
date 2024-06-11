#!/usr/bin/bash

#   8:          0          0          0          0     GIC-0 195 Level     edma_txcmpl_4
#   9:          0          0          0          0     GIC-0 196 Level     edma_txcmpl_5
#  10:          0          0          0          0     GIC-0 197 Level     edma_txcmpl_6
#  11:          0          0          0          0     GIC-0 198 Level     edma_txcmpl_7
#  12:    2418067          0          0          0     GIC-0 199 Level     edma_txcmpl_8
#  13:    6213514          0          0          0     GIC-0 200 Level     edma_txcmpl_9
#  14:    5328582          0          0          0     GIC-0 201 Level     edma_txcmpl_10
#  15:    8358255          0          0          0     GIC-0 202 Level     edma_txcmpl_11
#  16:      84106          0          0          0     GIC-0 203 Level     edma_txcmpl_12
#  17:    6980398          0          0          0     GIC-0 204 Level     edma_txcmpl_13
#  18:    6328330          0          0          0     GIC-0 205 Level     edma_txcmpl_14
#  19:    7331309          0          0          0     GIC-0 206 Level     edma_txcmpl_15
#  20:   61499583          0          0          0     GIC-0 171 Level     edma_rxdesc_12
#  21:    6749614          0          0          0     GIC-0 172 Level     edma_rxdesc_13
#  22:    6345344          0          0          0     GIC-0 173 Level     edma_rxdesc_14
#  23:    5744411          0          0          0     GIC-0 174 Level     edma_rxdesc_15
#  24:          0          0          0          0     GIC-0 223 Level     edma_misc

echo_and_run () {
    cmd=$1
    echo "${cmd}"
    eval "${cmd}"
}

CORES="0-3"
NIC="edma"

echo "BEFORE"
cmd="grep ${NIC} /proc/interrupts"
echo_and_run "${cmd}"

for i in $(seq 8 24);
do

  echo "Loop:${i}"
  cmd="echo ${CORES} > /proc/irq/${i}/smp_affinity_list"
  echo_and_run "${cmd}"
  cmd="cat /proc/irq/${i}/smp_affinity_list"
  echo_and_run "${cmd}"

done

echo "AFTER"
cmd="grep ${NIC} /proc/interrupts"
echo_and_run "${cmd}"

#end