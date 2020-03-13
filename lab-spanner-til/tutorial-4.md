# Tutorial

## Introduction

03-maximizing-data-load-throughput/version02

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="spanner-instance" value="spanner-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-database" value="db-00"></walkthrough-watcher-constant>

spanner-instance = {{spanner-instance}}

spanner-database = {{spanner-database}}

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
```bash
gcloud config set spanner/instance {{spanner-instance}}
```

### gsutil

None

### bq

None


## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,storage-api.googleapis.com,storage-component.googleapis.com,spanner.googleapis.com"></walkthrough-enable-apis>

## Create Accounts

None

## Grant Permissions

None

## Create VM

## Create Spanner

## Generate Sample Data

## Load Test

## Reset Spanner

## Clean Up

```bash
TODO
```
