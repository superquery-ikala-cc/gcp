# Tutorial

<walkthrough-watcher-constant key="custom-var" value="none"></walkthrough-watcher-constant>

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com"></walkthrough-enable-apis>

## Grant Permissions

n/a

## Run Benchmark

On the on-prem-loadtest VM, run this command:

```bash
sudo apt-get install iperf
```

```bash
iperf -s -i 5 -p 5001
```

On the cloud-loadtest VM, run this command:

```bash
sudo apt-get install iperf
```

```bash
iperf -c 192.168.1.2 -P 40 -x C -p 5001 -t 60
```

[iperf usage](http://manpages.ubuntu.com/manpages/xenial/man1/iperf.1.html)

<walkthrough-footnote>NOTE: 192.168.1.2 is the on-prem-loadtest VM's internal IP address.</walkthrough-footnote>

### Bottleneck

On the on-prem-strongswan VM, single thread software interrupt (si) 100%.

To fix this issue visit [doc1](https://wiki.strongswan.org/projects/strongswan/wiki/Pcrypt) and [doc2](https://wiki.strongswan.org/issues/2294)

```bash
sudo modprobe pcrypt
```
```bash
sudo modprobe tcrypt alg="pcrypt(authenc(hmac(sha256),cbc(aes)))" type=3
```
```bash
sudo modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
```
```bash
sudo modprobe tcrypt alg="pcrypt(authenc(hmac(sha1-ssse3),cbc-aes-aesni))" type=3
```
```bash
sudo lsmod | grep crypt
```
```bash
sudo cat /proc/crypto | grep pcrypt
```
```bash
sudo ipsec restart
```

## Create VPC 1

For Cloud

```bash
gcloud compute networks create cloud --subnet-mode custom
```

```bash
gcloud compute firewall-rules create cloud-fw --network cloud --allow tcp:22,icmp
```

```bash
gcloud compute networks subnets create cloud-east --network cloud --range 10.0.1.0/24 --region us-east1
```

## Create VPC 2

For On-prem

```bash
gcloud compute networks create on-prem --subnet-mode custom
```

```bash
gcloud compute firewall-rules create on-prem-fw --network on-prem --allow tcp:22,icmp
```

```bash
gcloud compute networks subnets create on-prem-central --network on-prem --range 192.168.1.0/24 --region us-central1
```

```bash
gcloud compute firewall-rules create on-prem-iperf-fw --network on-prem --allow tcp:5001
```

```bash
gcloud compute firewall-rules create on-prem-strongswan-fw --network on-prem --allow udp:500,udp:4500,esp --target-tags "strongswan"
```

```bash
gcloud compute firewall-rules create on-prem-internal-fw --network on-prem --allow all --source-ranges "192.168.1.0/24"
```

## Create Tunnels

route-based VPN tunnel

### Gateway

```bash
gcloud compute target-vpn-gateways create cloud-gw1 --network cloud --region us-east1
```

### IP Address

```bash
gcloud compute addresses create cloud-gw1 --region us-east1
```

```bash
gcloud compute addresses create on-prem-gw1 --region us-central1
```

```bash
cloud_gw1_ip=$(gcloud compute addresses describe cloud-gw1 --region us-east1 --format='value(address)')
```

```bash
on_prem_gw_ip=$(gcloud compute addresses describe on-prem-gw1 --region us-central1 --format='value(address)')
```

### Forwarding Rule

```bash
gcloud compute forwarding-rules create cloud-1-fr-esp --ip-protocol ESP --address $cloud_gw1_ip --target-vpn-gateway cloud-gw1 --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-1-fr-udp500 --ip-protocol UDP --ports 500 --address $cloud_gw1_ip --target-vpn-gateway cloud-gw1 --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-fr-1-udp4500 --ip-protocol UDP --ports 4500 --address $cloud_gw1_ip --target-vpn-gateway cloud-gw1 --region us-east1
```

### Tunnel

```bash
gcloud compute vpn-tunnels create cloud-tunnel1 --peer-address $on_prem_gw_ip --target-vpn-gateway cloud-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret --region us-east1
```

### Route

```bash
gcloud compute routes create on-prem-route1 --destination-range 10.0.1.0/24 --network on-prem --next-hop-instance on-prem-strongswan --next-hop-instance-zone us-central1-a
```

```bash
gcloud compute routes create cloud-route1 --destination-range 192.168.1.0/24 --network cloud --next-hop-vpn-tunnel cloud-tunnel1 --next-hop-vpn-tunnel-region us-east1
```

## Create VMs

```bash
gcloud compute instances create "cloud-loadtest" --zone "us-east1-b" --machine-type "n1-standard-4" --subnet "cloud-east" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "cloud-loadtest"
```

```bash
gcloud compute instances create "on-prem-loadtest" --zone "us-central1-a" --machine-type "n1-standard-4" --subnet "on-prem-central" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "on-prem-loadtest"
```

```bash
gcloud compute instances create "on-prem-strongswan" --zone "us-central1-a" --machine-type "n1-standard-4" --subnet "on-prem-central" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "on-prem-strongswan" --address $on_prem_gw_ip --can-ip-forward --tags strongswan
```

## Strongswan

```bash
sudo apt-get update
```

```bash
sudo apt-get install strongswan
```

### /etc/sysctl.conf

```bash
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
```

```bash
sudo sysctl -p /etc/sysctl.conf
```

### /etc/ipsec.secrets

```bash
echo "$on_prem_gw_ip $cloud_gw1_ip : PSK \"sharedsecret\"" | sudo tee -a /etc/ipsec.secrets
```

### /etc/ipsec.conf

```terminal
conn %default
    authby=psk
    auto=route
    dpdaction=hold
    ike=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
    esp=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
    forceencaps=yes
    keyexchange=ikev2
    mobike=no
    type=tunnel
    leftauth=psk
    leftikeport=4500
    rightauth=psk
    rightikeport=4500

conn on-prem-to-cloud
    left=%any
    leftid=35.232.63.67
    leftsubnet=192.168.1.0/24
    right=34.74.2.191
    rightid=34.74.2.191
    rightsubnet=10.0.1.0/24
```

<walkthrough-footnote>NOTE: 10.0.1.0/24 cloud subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 192.168.1.0/24 on-prem subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 34.74.2.191 cloud gateway IP</walkthrough-footnote>
<walkthrough-footnote>NOTE: 35.232.63.67 on-prem gateway IP</walkthrough-footnote>

### Restart

```bash
sudo ipsec restart
```

```bash
sudo ipsec up on-prem-to-cloud
```

```bash
sudo ipsec status
```

## Add More Tunnels 2a

<walkthrough-watcher-constant key="tunnel-count" value="2"></walkthrough-watcher-constant>

### Gateway

```bash
gcloud compute target-vpn-gateways create cloud-gw{{tunnel-count}} --network cloud --region us-east1
```

### IP Address

```bash
gcloud compute addresses create cloud-gw{{tunnel-count}} --region us-east1
```

```bash
cloud_gw{{tunnel-count}}_ip=$(gcloud compute addresses describe cloud-gw{{tunnel-count}} --region us-east1 --format='value(address)')
```

### Forwarding Rule

```bash
gcloud compute forwarding-rules create cloud-{{tunnel-count}}-fr-esp --ip-protocol ESP --address $cloud_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-{{tunnel-count}}-fr-udp500 --ip-protocol UDP --ports 500 --address $cloud_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-fr-{{tunnel-count}}-udp4500 --ip-protocol UDP --ports 4500 --address $cloud_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --region us-east1
```

### Tunnel

```bash
gcloud compute vpn-tunnels create cloud-tunnel{{tunnel-count}} --peer-address $on_prem_gw_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret{{tunnel-count}} --region us-east1
```

### Route

```bash
gcloud compute routes create cloud-route{{tunnel-count}} --destination-range 192.168.1.0/24 --network cloud --next-hop-vpn-tunnel cloud-tunnel{{tunnel-count}} --next-hop-vpn-tunnel-region us-east1
```

### /etc/ipsec.secrets

```bash
echo "$on_prem_gw_ip $cloud_gw{{tunnel-count}}_ip : PSK \"sharedsecret{{tunnel-count}}\"" | sudo tee -a /etc/ipsec.secrets
```

### /etc/ipsec.conf

```terminal

conn on-prem-to-cloud{{tunnel-count}}
    left=%any
    leftid=35.232.63.67
    leftsubnet=192.168.1.0/24
    right=35.243.175.127
    rightid=35.243.175.127
    rightsubnet=10.0.1.0/24
```

<walkthrough-footnote>NOTE: 10.0.1.0/24 cloud subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 192.168.1.0/24 on-prem subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 35.243.175.127 cloud gateway IP</walkthrough-footnote>
<walkthrough-footnote>NOTE: 35.232.63.67 on-prem gateway IP</walkthrough-footnote>

### Restart

```bash
sudo ipsec restart
```

```bash
sudo ipsec up on-prem-to-cloud
```

```bash
sudo ipsec up on-prem-to-cloud2
```

```bash
sudo ipsec status
```

### Problem

VPN tunnel status ok but routing issue occurs between cloud-loadtest and on-prem-loadtest

## Add More Tunnels 2b

<walkthrough-watcher-constant key="tunnel-count" value="2"></walkthrough-watcher-constant>

### Gateway

```bash
gcloud compute target-vpn-gateways create cloud-gw{{tunnel-count}} --network cloud --region us-east1
```

### IP Address

```bash
gcloud compute addresses create cloud-gw{{tunnel-count}} --region us-east1
```

```bash
gcloud compute addresses create on-prem-gw{{tunnel-count}} --region us-central1
```

```bash
cloud_gw{{tunnel-count}}_ip=$(gcloud compute addresses describe cloud-gw{{tunnel-count}} --region us-east1 --format='value(address)')
```

```bash
on_prem_gw{{tunnel-count}}_ip=$(gcloud compute addresses describe on-prem-gw{{tunnel-count}} --region us-central1 --format='value(address)')
```

### Forwarding Rule

```bash
gcloud compute forwarding-rules create cloud-{{tunnel-count}}-fr-esp --ip-protocol ESP --address $cloud_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-{{tunnel-count}}-fr-udp500 --ip-protocol UDP --ports 500 --address $cloud_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-fr-{{tunnel-count}}-udp4500 --ip-protocol UDP --ports 4500 --address $cloud_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --region us-east1
```

### Tunnel

```bash
gcloud compute vpn-tunnels create cloud-tunnel{{tunnel-count}} --peer-address $on_prem_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw{{tunnel-count}} --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret{{tunnel-count}} --region us-east1
```

### Route

```bash
gcloud compute routes create on-prem-route{{tunnel-count}} --destination-range 10.0.1.0/24 --network on-prem --next-hop-instance on-prem-strongswan{{tunnel-count}} --next-hop-instance-zone us-central1-a
```

```bash
gcloud compute routes create cloud-route{{tunnel-count}} --destination-range 192.168.1.0/24 --network cloud --next-hop-vpn-tunnel cloud-tunnel{{tunnel-count}} --next-hop-vpn-tunnel-region us-east1
```

### VM

```bash
gcloud compute instances create "on-prem-strongswan{{tunnel-count}}" --zone "us-central1-a" --machine-type "n1-standard-4" --subnet "on-prem-central" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "on-prem-strongswan{{tunnel-count}}" --address $on_prem_gw{{tunnel-count}}_ip --can-ip-forward --tags strongswan
```

### Strongswan{{tunnel-count}}

```bash
sudo apt-get update
```

```bash
sudo apt-get install strongswan
```

### /etc/sysctl.conf

```bash
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
```

```bash
sudo sysctl -p /etc/sysctl.conf
```

### /etc/ipsec.secrets

```bash
echo "$on_prem_gw{{tunnel-count}}_ip $cloud_gw{{tunnel-count}}_ip : PSK \"sharedsecret{{tunnel-count}}\"" | sudo tee -a /etc/ipsec.secrets
```

### /etc/ipsec.conf

```terminal
conn %default
    authby=psk
    auto=route
    dpdaction=hold
    ike=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
    esp=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
    forceencaps=yes
    keyexchange=ikev2
    mobike=no
    type=tunnel
    leftauth=psk
    leftikeport=4500
    rightauth=psk
    rightikeport=4500

conn on-prem-to-cloud{{tunnel-count}}
    left=%any
    leftid=35.188.211.5
    leftsubnet=192.168.1.0/24
    right=35.243.175.127
    rightid=35.243.175.127
    rightsubnet=10.0.1.0/24
```

<walkthrough-footnote>NOTE: 10.0.1.0/24 cloud subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 192.168.1.0/24 on-prem subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 35.243.175.127 cloud gateway IP</walkthrough-footnote>
<walkthrough-footnote>NOTE: 35.188.211.5 on-prem gateway IP</walkthrough-footnote>

### Restart

```bash
sudo ipsec restart
```

```bash
sudo ipsec up on-prem-to-cloud{{tunnel-count}}
```

```bash
sudo ipsec status
```

### Repeat 

Benchmark result shows that adding 1 pair gateways (cloud,on-prem) increases throughput of 1G.

So we need repeat above steps for 10 pairs.

## Add More Tunnels 2c

<walkthrough-watcher-constant key="tunnel-count" value="2"></walkthrough-watcher-constant>

### IP Address

```bash
gcloud compute addresses create on-prem-gw{{tunnel-count}} --region us-central1
```

```bash
on_prem_gw{{tunnel-count}}_ip=$(gcloud compute addresses describe on-prem-gw{{tunnel-count}} --region us-central1 --format='value(address)')
```

### Tunnel

```bash
gcloud compute vpn-tunnels create cloud-tunnel{{tunnel-count}} --peer-address $on_prem_gw{{tunnel-count}}_ip --target-vpn-gateway cloud-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret{{tunnel-count}} --region us-east1
```

### Route

```bash
gcloud compute routes create on-prem-route{{tunnel-count}} --destination-range 10.0.1.0/24 --network on-prem --next-hop-instance on-prem-strongswan{{tunnel-count}} --next-hop-instance-zone us-central1-a
```

```bash
gcloud compute routes create cloud-route{{tunnel-count}} --destination-range 192.168.1.0/24 --network cloud --next-hop-vpn-tunnel cloud-tunnel{{tunnel-count}} --next-hop-vpn-tunnel-region us-east1
```

### VM

```bash
gcloud compute instances create "on-prem-strongswan{{tunnel-count}}" --zone "us-central1-a" --machine-type "n1-standard-4" --subnet "on-prem-central" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "on-prem-strongswan{{tunnel-count}}" --address $on_prem_gw{{tunnel-count}}_ip --can-ip-forward --tags strongswan
```

### Strongswan{{tunnel-count}}

```bash
sudo apt-get update
```

```bash
sudo apt-get install strongswan
```

### /etc/sysctl.conf

```bash
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
```

```bash
sudo sysctl -p /etc/sysctl.conf
```

### /etc/ipsec.secrets

```bash
echo "$on_prem_gw{{tunnel-count}}_ip $cloud_gw1_ip : PSK \"sharedsecret{{tunnel-count}}\"" | sudo tee -a /etc/ipsec.secrets
```

### /etc/ipsec.conf

```terminal
conn %default
    authby=psk
    auto=route
    dpdaction=hold
    ike=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
    esp=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
    forceencaps=yes
    keyexchange=ikev2
    mobike=no
    type=tunnel
    leftauth=psk
    leftikeport=4500
    rightauth=psk
    rightikeport=4500

conn on-prem-to-cloud{{tunnel-count}}
    left=%any
    leftid=35.188.211.5
    leftsubnet=192.168.1.0/24
    right=34.74.2.191
    rightid=34.74.2.191
    rightsubnet=10.0.1.0/24
```

<walkthrough-footnote>NOTE: 10.0.1.0/24 cloud subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 192.168.1.0/24 on-prem subnet CIDR</walkthrough-footnote>
<walkthrough-footnote>NOTE: 34.74.2.191 cloud gateway IP</walkthrough-footnote>
<walkthrough-footnote>NOTE: 35.188.211.5 on-prem gateway IP</walkthrough-footnote>

### Restart

```bash
sudo ipsec restart
```

```bash
sudo ipsec up on-prem-to-cloud{{tunnel-count}}
```

```bash
sudo ipsec status
```

### Repeat 

Benchmark result shows that adding 1 on-prem gateway increases throughput of 1G.

So we need repeat above steps for 10 on-prem gateways.

## Clean Up

```bash
TODO
```
