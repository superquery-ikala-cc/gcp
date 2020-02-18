# Tutorial-02

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com"></walkthrough-enable-apis>

## Create A Network

```bash
gcloud compute networks create cloud-net --subnet-mode=custom
```

## Create A Subnet

```bash
gcloud compute networks subnets create cloud-db-subnet --network=cloud-net --range=192.168.200.0/24 --region=asia-east1
```

## Create A Server

```bash
gcloud compute instances create slave-db --network=cloud-net --subnet=cloud-db-subnet --zone=asia-east1-a
```

## Setup Firewall

```bash
gcloud compute firewall-rules create cloud-fw-ssh-rule --network=cloud-net --allow=tcp:22 --source-ranges=0.0.0.0/0
```

<walkthrough-footnote>NOTE: source range 0.0.0.0/0 is NOT recommended in the production environment</walkthrough-footnote>

## Clean Up

```bash
gcloud compute instances delete slave-db --zone=asia-east1-a
gcloud compute networks subnets delete cloud-db-subnet --region=asia-east1
gcloud compute networks delete cloud-net
```
