# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="bucket-name" value="data-user-pay-bucket"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="dataset-name" value="data-user-pay-dataset"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="service-account-for-data-user" value="data-user"></walkthrough-watcher-constant>

bucket-name = {{bucket-name}}

dataset-name = {{dataset-name}}

service-account-for-data-user = {{service-account-for-data-user}}

## Setup Project X

For data user

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Setup Cloud SDK

For data user

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

For data user

<walkthrough-enable-apis apis="bigquery.googleapis.com,bigquerystorage.googleapis.com,bigtableadmin.googleapis.com,storage-api.googleapis.com,storage-component.googleapis.com"></walkthrough-enable-apis>

## Create Accounts

For data user

```bash
gcloud iam service-accounts create {{service-account-for-data-user}}
```

## Grant Permissions

For data user

### GCS

Project level
* Permission serviceusage.services.use
* OR Service Usage Consumer
* OR Project Editor

Resource level (bucket)
* none

### BQ

Project level
* BigQuery Job User

Resource level (dataset)
* none

## Create VM

```bash
gcloud compute instances create data-user-vm --service-account={{service-account-for-data-user}}@{{project-id}}.iam.gserviceaccount.com --scopes=cloud-platform
```

## Verify

### GCS

```
gsutil -u {{project-id}} cat gs://{{bucket-name}}/readme.txt
```

### BQ

```
bq query --use_legacy_sql=false 'SELECT * FROM DATA-OWNER-PROJECT.{{dataset-name}}.readme'
```

## Setup Project Y

For data owner

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

<walkthrough-enable-apis apis="bigquery.googleapis.com,bigquerystorage.googleapis.com,bigtableadmin.googleapis.com,storage-api.googleapis.com,storage-component.googleapis.com"></walkthrough-enable-apis>

## Create Accounts

None

## Grant Permissions

### GCS

Project level
* none

Resource level (bucket)
* Storage Object Viewer

### BQ

Project level
* BigQuery Read Session User

Resource level (dataset)
* BigQuery Data Viewer

## Create TODO

## Clean Up

```bash
TODO
```
