#!/usr/bin/bash

parallel=20
i=1
ts=$(date +%Y_%m_%d_%H_%M_%S)
./iperf_client_firewall_test.bash "${parallel}" "${i}" | tee "output_${parallel}_${ts}"

# end