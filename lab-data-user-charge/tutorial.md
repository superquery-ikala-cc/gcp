# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="bucket-name" value="data-user-pay-bucket"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="dataset-name" value="data-user-pay-dataset"></walkthrough-watcher-constant>

bucket-name = {{bucket-name}}

dataset-name = {{dataset-name}}

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

## Create TODO

## Clean Up

```bash
TODO
```
