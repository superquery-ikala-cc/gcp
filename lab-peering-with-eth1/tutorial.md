# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="vpc-a-0" value="vpc-a-0"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-a-1" value="vpc-a-1"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-b-0" value="vpc-b-0"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-b-1" value="vpc-b-1"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-a-0-subnet-ip-range" value="192.168.100.0/24"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-a-1-subnet-ip-range" value="192.168.101.0/24"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-b-0-subnet-ip-range" value="192.168.200.0/24"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-b-1-subnet-ip-range" value="192.168.201.0/24"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vm-a" value="vm-a"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vm-b" value="vm-b"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vm-a-0" value="vm-a-0"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vm-a-1" value="vm-a-1"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vm-b-0" value="vm-b-0"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vm-b-1" value="vm-b-1"></walkthrough-watcher-constant>

vpc-a-0 = {{vpc-a-0}}

vpc-a-1 = {{vpc-a-1}}

vpc-b-0 = {{vpc-b-0}}

vpc-b-1 = {{vpc-b-1}}

vpc-a-0-subnet-ip-range = {{vpc-a-0-subnet-ip-range}}

vpc-a-1-subnet-ip-range = {{vpc-a-1-subnet-ip-range}}

vpc-b-0-subnet-ip-range = {{vpc-b-0-subnet-ip-range}}

vpc-b-1-subnet-ip-range = {{vpc-b-1-subnet-ip-range}}

vm-a = {{vm-a}}

vm-b = {{vm-b}}

vm-a-0 = {{vm-a-0}}

vm-a-1 = {{vm-a-1}}

vm-b-0 = {{vm-b-0}}

vm-b-1 = {{vm-b-1}}

## Setup Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Setup Cloud SDK

### gcloud

```bash
gcloud config set core/project {{project-id}}
```
```bash
gcloud config set compute/region asia-east1
```
```bash
gcloud config set compute/zone asia-east1-a
```

### gsutil

None

### bq

None


## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com"></walkthrough-enable-apis>

## Create Accounts

None

## Grant Permissions

None

## Create VPC

### vpc-a-0

```bash
gcloud compute networks create {{vpc-a-0}} --subnet-mode custom
```
```bash
gcloud compute networks subnets create {{vpc-a-0}}-subnet --network {{vpc-a-0}} --range {{vpc-a-0-subnet-ip-range}}
```
```bash
gcloud compute firewall-rules create {{vpc-a-0}}-fw --network {{vpc-a-0}} --allow tcp:22,icmp
```

### vpc-a-1

```bash
gcloud compute networks create {{vpc-a-1}} --subnet-mode custom
```
```bash
gcloud compute networks subnets create {{vpc-a-1}}-subnet --network {{vpc-a-1}} --range {{vpc-a-1-subnet-ip-range}}
```
```bash
gcloud compute firewall-rules create {{vpc-a-1}}-fw --network {{vpc-a-1}} --allow tcp:22,icmp
```

### vpc-b-0

```bash
gcloud compute networks create {{vpc-b-0}} --subnet-mode custom
```
```bash
gcloud compute networks subnets create {{vpc-b-0}}-subnet --network {{vpc-b-0}} --range {{vpc-b-0-subnet-ip-range}}
```
```bash
gcloud compute firewall-rules create {{vpc-b-0}}-fw --network {{vpc-b-0}} --allow tcp:22,icmp
```

### vpc-b-1

```bash
gcloud compute networks create {{vpc-b-1}} --subnet-mode custom
```
```bash
gcloud compute networks subnets create {{vpc-b-1}}-subnet --network {{vpc-b-1}} --range {{vpc-b-1-subnet-ip-range}}
```
```bash
gcloud compute firewall-rules create {{vpc-b-1}}-fw --network {{vpc-b-1}} --allow tcp:22,icmp
```

## Create Peering

```bash
gcloud compute networks peerings create peer-a-1-to-b-1 --auto-create-routes --network={{vpc-a-1}} --peer-project {{project-id}} --peer-network {{vpc-b-1}}
```
```bash
gcloud compute networks peerings create peer-b-1-to-a-1 --auto-create-routes --network={{vpc-b-1}} --peer-project {{project-id}} --peer-network {{vpc-a-1}}
```

## Create VM

### vm-a-0

```bash
gcloud compute instances create {{vm-a-0}} --subnet {{vpc-a-0}}-subnet --image-family debian-9 --image-project debian-cloud --metadata="enable-oslogin=TRUE,startup-script=apt-get update"
```

### vm-a-1

```bash
gcloud compute instances create {{vm-a-1}} --subnet {{vpc-a-1}}-subnet --image-family debian-9 --image-project debian-cloud --metadata="enable-oslogin=TRUE,startup-script=apt-get update"
```

### vm-a

```bash
gcloud compute instances create {{vm-a}} --network-interface subnet={{vpc-a-0}}-subnet --network-interface subnet={{vpc-a-1}}-subnet --image-family debian-9 --image-project debian-cloud --metadata="enable-oslogin=TRUE,startup-script=apt-get update"
```

### vm-b-0

```bash
gcloud compute instances create {{vm-b-0}} --subnet {{vpc-b-0}}-subnet --image-family centos-7 --image-project centos-cloud --metadata="enable-oslogin=TRUE,startup-script=yum upgrade"
```

### vm-b-1

```bash
gcloud compute instances create {{vm-b-1}} --subnet {{vpc-b-1}}-subnet --image-family centos-7 --image-project centos-cloud --metadata="enable-oslogin=TRUE,startup-script=yum upgrade"
```

### vm-b

```bash
gcloud compute instances create {{vm-b}} --network-interface subnet={{vpc-b-0}}-subnet --network-interface subnet={{vpc-b-1}}-subnet --image-family centos-7 --image-project centos-cloud --metadata="enable-oslogin=TRUE,startup-script=yum upgrade"
```

## Update Startup Script

### vm-a

TODO: update startup-script-for-debian.sh

```bash
gcloud compute instances add-metadata {{vm-a}} --metadata-from-file startup-script=startup-script-for-debian.sh 
```

### vm-b

TODO: update startup-script-for-centos.sh 

```bash
gcloud compute instances add-metadata {{vm-b}} --metadata-from-file startup-script=startup-script-for-centos.sh 
```

### Re-Run Script

```
sudo google_metadata_script_runner --script-type startup --debug
```

## Restart VM

```bash
gcloud compute instances reset vm-a
```
```bash
gcloud compute instances reset vm-b
```

## Verify

vm-a <- - using eth1 - -> vm-b

## Clean Up

```bash
TODO
```
