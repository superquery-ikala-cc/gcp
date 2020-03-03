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
iperf -c 192.168.1.2 -P 20 -x C -p 5001
```

<walkthrough-footnote>NOTE: 192.168.1.2 is the on-prem-loadtest VM's internal IP address.</walkthrough-footnote>

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

## Create Tunnels

route-based VPN tunnel

### Gateway

```bash
gcloud compute target-vpn-gateways create on-prem-gw1 --network on-prem --region us-central1
```

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

```bash
gcloud compute forwarding-rules create on-prem-fr-esp --ip-protocol ESP --address $on_prem_gw_ip --target-vpn-gateway on-prem-gw1 --region us-central1
```

```bash
gcloud compute forwarding-rules create on-prem-fr-udp500 --ip-protocol UDP --ports 500 --address $on_prem_gw_ip --target-vpn-gateway on-prem-gw1 --region us-central1
```

```bash
gcloud compute forwarding-rules create on-prem-fr-udp4500 --ip-protocol UDP --ports 4500 --address $on_prem_gw_ip --target-vpn-gateway on-prem-gw1 --region us-central1
```

### Tunnel

```bash
gcloud compute vpn-tunnels create on-prem-tunnel1 --peer-address $cloud_gw1_ip --target-vpn-gateway on-prem-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret --region us-central1
```

```bash
gcloud compute vpn-tunnels create cloud-tunnel1 --peer-address $on_prem_gw_ip --target-vpn-gateway cloud-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret --region us-east1
```

### Route

```bash
gcloud compute routes create on-prem-route1 --destination-range 10.0.1.0/24 --network on-prem --next-hop-vpn-tunnel on-prem-tunnel1 --next-hop-vpn-tunnel-region us-central1
```

```bash
gcloud compute routes create cloud-route1 --destination-range 192.168.1.0/24 --network cloud --next-hop-vpn-tunnel cloud-tunnel1 --next-hop-vpn-tunnel-region us-east1
```

## Add More Tunnels

### Gateway

```bash
gcloud compute target-vpn-gateways create cloud-gw2 --network cloud --region us-east1
```

### IP Address

```bash
gcloud compute addresses create cloud-gw2 --region us-east1
```

```bash
cloud_gw2_ip=$(gcloud compute addresses describe cloud-gw2 --region us-east1 --format='value(address)')
```

### Forwarding Rule

```bash
gcloud compute forwarding-rules create cloud-2-fr-esp --ip-protocol ESP --address $cloud_gw2_ip --target-vpn-gateway cloud-gw2 --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-2-fr-udp500 --ip-protocol UDP --ports 500 --address $cloud_gw2_ip --target-vpn-gateway cloud-gw2 --region us-east1
```

```bash
gcloud compute forwarding-rules create cloud-fr-2-udp4500 --ip-protocol UDP --ports 4500 --address $cloud_gw2_ip --target-vpn-gateway cloud-gw2 --region us-east1
```

### Tunnel

```bash
gcloud compute vpn-tunnels create on-prem-tunnel2 --peer-address $cloud_gw2_ip --target-vpn-gateway on-prem-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret2 --region us-central1
```

```bash
gcloud compute vpn-tunnels create cloud-tunnel2 --peer-address $on_prem_gw_ip --target-vpn-gateway cloud-gw2 --ike-version 2 --local-traffic-selector 0.0.0.0/0 --remote-traffic-selector 0.0.0.0/0 --shared-secret=sharedsecret2 --region us-east1
```

### Route

```bash
gcloud compute routes create on-prem-route2 --destination-range 10.0.1.0/24 --network on-prem --next-hop-vpn-tunnel on-prem-tunnel2 --next-hop-vpn-tunnel-region us-central1
```

```
gcloud compute routes create cloud-route2 --destination-range 192.168.1.0/24 --network cloud --next-hop-vpn-tunnel cloud-tunnel2 --next-hop-vpn-tunnel-region us-east1
```

## Create VMs

```bash
gcloud compute instances create "cloud-loadtest" --zone "us-east1-b" --machine-type "n1-standard-4" --subnet "cloud-east" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "cloud-loadtest"
```

```bash
gcloud compute instances create "on-prem-loadtest" --zone "us-central1-a" --machine-type "n1-standard-4" --subnet "on-prem-central" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "on-prem-loadtest"
```

## Clean Up

```bash
TODO
```
