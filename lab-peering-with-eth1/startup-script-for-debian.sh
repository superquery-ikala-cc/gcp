#!/bin/bash

if [ ! -f /opt/network-init-once ]; then
    # step 1
    cat > /etc/default/instance_configs.cfg.template <<CONFIG
[NetworkInterfaces]
setup = false
CONFIG

    # step 2
    echo "1 rt1" >> /etc/iproute2/rt_tables
    cat >> /etc/network/interfaces <<CONFIG
auto eth1
iface eth1 inet dhcp
  up ip route add default via 192.168.101.1 dev eth1 table rt1
  up ip rule add to 192.168.201.0/24 table rt1
CONFIG

    touch /opt/network-init-once
    echo "done network-init"

    # step 3
    init 6
fi
