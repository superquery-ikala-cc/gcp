# Tutorial-03

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Creating a Classic VPN using **static** **policy-based** routing ([doc](https://cloud.google.com/vpn/docs/how-to/creating-static-vpns))

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com"></walkthrough-enable-apis>

## Prepare Static Public IPs

### Reserve a regional external (static) IP address for on-prem VPN Gateway

```bash
gcloud compute addresses create on-prem-vpn-gw-ip --region=asia-east1
```
```bash
on_prem_vpn_gw_ip=$(gcloud compute addresses describe on-prem-vpn-gw-ip --region=asia-east1 --format='get(address)')
```

### Reserve a regional external (static) IP address for cloud VPN Gateway

```bash
gcloud compute addresses create cloud-vpn-gw-ip --region=asia-northeast1
```
```bash
cloud_vpn_gw_ip=$(gcloud compute addresses describe cloud-vpn-gw-ip --region=asia-northeast1 --format='get(address)')
```

## Setup On-Prem VPN

### Firewall

```bash
gcloud compute firewall-rules create on-prem-fw-vpn-rule --network=on-prem-net --allow=tcp,udp,icmp --source-ranges=192.168.200.0/24
```

### VPN Gateway

```bash
gcloud compute target-vpn-gateways create on-prem-vpn-gw --network=on-prem-net --region=asia-east1
```

### Forwarding Rule

These rules instruct Google Cloud to send ESP (IPsec), UDP 500, and UDP 4500 traffic to the gateway.

```bash
gcloud compute forwarding-rules create on-prem-vpn-gw-fr-esp --ip-protocol=ESP --address=on-prem-vpn-gw-ip --target-vpn-gateway=on-prem-vpn-gw --region=asia-east1

gcloud compute forwarding-rules create on-prem-vpn-gw-fr-udp500 --ip-protocol=UDP --ports=500 --address=on-prem-vpn-gw-ip --target-vpn-gateway=on-prem-vpn-gw --region=asia-east1

gcloud compute forwarding-rules create on-prem-vpn-gw-fr-udp4500 --ip-protocol=UDP --ports=4500 --address=on-prem-vpn-gw-ip --target-vpn-gateway=on-prem-vpn-gw --region=asia-east1
```

### Policy-Based VPN Tunnel

```bash
gcloud compute vpn-tunnels create on-prem-vpn-gw-tunnel --peer-address=${cloud_vpn_gw_ip} --ike-version=2 --shared-secret=shared-secret --local-traffic-selector=192.168.100.0/24 --remote-traffic-selector=192.168.200.0/24 --target-vpn-gateway=on-prem-vpn-gw --region=asia-east1
```

### Route

```bash
gcloud compute routes create on-prem-vpn-gw-route --destination-range=192.168.200.0/24 --network=on-prem-net --next-hop-vpn-tunnel-region=asia-east1 --next-hop-vpn-tunnel=on-prem-vpn-gw-tunnel 
```

## Setup Cloud VPN

### Firewall

```bash
gcloud compute firewall-rules create cloud-fw-vpn-rule --network=cloud-net --allow=tcp,udp,icmp --source-ranges=192.168.100.0/24
```

### VPN Gateway

```bash
gcloud compute target-vpn-gateways create cloud-vpn-gw --network=cloud-net --region=asia-east1
```

### Forwarding Rule

These rules instruct Google Cloud to send ESP (IPsec), UDP 500, and UDP 4500 traffic to the gateway.

```bash
gcloud compute forwarding-rules create cloud-vpn-gw-fr-esp --ip-protocol=ESP --address=cloud-vpn-gw-ip --target-vpn-gateway=cloud-vpn-gw --region=asia-east1

gcloud compute forwarding-rules create cloud-vpn-gw-fr-udp500 --ip-protocol=UDP --ports=500 --address=cloud-vpn-gw-ip --target-vpn-gateway=cloud-vpn-gw --region=asia-east1

gcloud compute forwarding-rules create cloud-vpn-gw-fr-udp4500 --ip-protocol=UDP --ports=4500 --address=cloud-vpn-gw-ip --target-vpn-gateway=cloud-vpn-gw --region=asia-east1
```

### Policy-Based VPN Tunnel

```bash
gcloud compute vpn-tunnels create cloud-vpn-gw-tunnel --peer-address=${on_prem_vpn_gw_ip} --ike-version=2 --shared-secret=shared-secret --local-traffic-selector=192.168.200.0/24 --remote-traffic-selector=192.168.100.0/24 --target-vpn-gateway=cloud-vpn-gw --region=asia-east1
```

### Route

```bash
gcloud compute routes create cloud-vpn-gw-route --destination-range=192.168.100.0/24 --network=cloud-net --next-hop-vpn-tunnel-region=asia-east1 --next-hop-vpn-tunnel=cloud-vpn-gw-tunnel 
```

## Check Status

### On-Prem VPN Tunnel

```bash
gcloud compute vpn-tunnels describe on-prem-vpn-gw-tunnel --region=asia-east1 --format='flattened(status,detailedStatus)'
```

### Cloud VPN Tunnel

```bash
gcloud compute vpn-tunnels describe cloud-vpn-gw-tunnel --region=asia-east1 --format='flattened(status,detailedStatus)'
```

## Clean Up

### On-Prem

```bash
gcloud compute routes delete on-prem-vpn-gw-route
gcloud compute vpn-tunnels delete on-prem-vpn-gw-tunnel
gcloud compute forwarding-rules delete on-prem-vpn-gw-fr-udp4500
gcloud compute forwarding-rules delete on-prem-vpn-gw-fr-udp500
gcloud compute forwarding-rules delete on-prem-vpn-gw-fr-esp
gcloud compute target-vpn-gateways delete on-prem-vpn-gw
gcloud compute addresses delete on-prem-vpn-gw-ip
```

### Cloud

```bash
gcloud compute routes delete cloud-vpn-gw-route
```
```bash
gcloud compute vpn-tunnels delete cloud-vpn-gw-tunnel
```
```bash
gcloud compute forwarding-rules delete cloud-vpn-gw-fr-udp4500
```
```bash
gcloud compute forwarding-rules delete cloud-vpn-gw-fr-udp500
```
```bash
gcloud compute forwarding-rules delete cloud-vpn-gw-fr-esp
```
```bash
gcloud compute target-vpn-gateways delete cloud-vpn-gw
```
```bash
gcloud compute addresses delete cloud-vpn-gw-ip
```
