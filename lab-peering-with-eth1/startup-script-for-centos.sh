if [ ! -f /opt/network-init-once ]; then
    # step 1
    cat > /etc/default/instance_configs.cfg.template <<CONFIG
[NetworkInterfaces]
setup = false
CONFIG

    # step 2
    cat >> /etc/sysconfig/network-scripts/ifcfg-eth1 <<CONFIG
BOOTPROTO=dhcp
DEFROUTE=no
DEVICE=eth1
IPV6INIT=no
NM_CONTROLLED=no
NOZEROCONF=yes
ONBOOT=yes
PERSISTENT_DHCLIENT=y
MTU=1460
CONFIG
    cat >> /etc/sysconfig/network-scripts/route-eth1 <<CONFIG
192.168.101.0/24 via 192.168.201.1 dev eth1
CONFIG

    touch /opt/network-init-once
    echo "done network-init"

    # step 3
    init 6
fi
