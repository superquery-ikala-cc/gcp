# Tutorial

## Configuration

<walkthrough-watcher-constant key="vpc-a-0" value="vpc-a-0"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-a-1" value="vpc-a-1"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-b-0" value="vpc-b-0"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="vpc-b-1" value="vpc-b-1"></walkthrough-watcher-constant>
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
vm-a = {{vm-a}}
vm-b = {{vm-b}}
vm-a-0 = {{vm-a-0}}
vm-a-1 = {{vm-a-1}}
vm-b-0 = {{vm-b-0}}
vm-b-1 = {{vm-b-1}}

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,servicenetworking.googleapis.com,sql-component.googleapis.com,sqladmin.googleapis.com,redis.googleapis.com,container.googleapis.com"></walkthrough-enable-apis>

## Grant Permissions

n/a

## Create VPC
## Create VM
## Create Peering

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
