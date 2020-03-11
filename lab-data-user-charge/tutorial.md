# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="bucket-name" value="data-user-pay-bucket"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="dataset-name" value="data-user-pay-dataset"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="data-user-account" value="data-user"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="data-user-project" value="gcp-expert-sandbox-jim"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="data-owner-project" value="eco-theater-268514"></walkthrough-watcher-constant>

bucket-name = {{bucket-name}}

dataset-name = {{dataset-name}}

data-user-account = {{data-user-account}}

data-user-project = {{data-user-project}}

data-owner-project = {{data-owner-project}}

## Setup Project X

For data user project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Setup Cloud SDK X

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

## Enable APIs X

<walkthrough-enable-apis apis="bigquery.googleapis.com,bigquerystorage.googleapis.com,storage-api.googleapis.com,storage-component.googleapis.com"></walkthrough-enable-apis>

## Create Accounts X

```bash
gcloud iam service-accounts create {{data-user-account}}
```

## Grant Permissions X

### GCS

Project level
* Permission serviceusage.services.use
* OR Service Usage Consumer
* OR Project Editor

```bash
gcloud projects add-iam-policy-binding {{project-id}} --member serviceAccount:{{data-user-account}}@{{project-id}}.iam.gserviceaccount.com --role roles/serviceusage.serviceUsageConsumer
```

Resource level (bucket)
* none

### BQ

Project level
* BigQuery Job User

```bash
gcloud projects add-iam-policy-binding {{project-id}} --member serviceAccount:{{data-user-account}}@{{project-id}}.iam.gserviceaccount.com --role roles/bigquery.jobUser
```

Resource level (dataset)
* none

## Create VM X

```bash
gcloud compute instances create data-user-vm --service-account={{data-user-account}}@{{project-id}}.iam.gserviceaccount.com --scopes=cloud-platform
```

## Verify X

### GCS

```
gsutil -u {{project-id}} cat gs://{{bucket-name}}/readme.txt
```

### BQ

```
bq query --use_legacy_sql=false 'SELECT * FROM {{data-owner-project}}.{{dataset-name}}.readme'
```

## Setup Project Y

For data owner project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Setup Cloud SDK Y

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

## Enable APIs Y

<walkthrough-enable-apis apis="bigquery.googleapis.com,bigquerystorage.googleapis.com,storage-api.googleapis.com,storage-component.googleapis.com"></walkthrough-enable-apis>

## Create Accounts Y

None

## Grant Permissions Y

### GCS

Project level
* none

Resource level (bucket)
* Storage Object Viewer

### BQ

Project level
* BigQuery Read Session User

```bash
gcloud projects add-iam-policy-binding {{project-id}} --member serviceAccount:{{data-user-account}}@{{data-user-project}}.iam.gserviceaccount.com --role roles/bigquery.readSessionUser
```

Resource level (dataset)
* BigQuery Data Viewer

## Create Bucket

```bash
```

### Grant Permission

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **Storage** section.

<walkthrough-menu-navigation sectionId="STORAGE_SECTION"></walkthrough-menu-navigation>


### Enable Requester Pay

```bash
```

### Create A File

```bash
```

### Enable Data Access Audit Log

```bash
```

## Create Dataset

```bash
```

### Grant Permission

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **BigQuery** section.

<walkthrough-menu-navigation sectionId="BIGQUERY_SECTION"></walkthrough-menu-navigation>

### Create A Table

```bash
```

## Clean Up

```bash
TODO
```

[spotlight-console-menu]: walkthrough://spotlight-pointer?spotlightId=console-nav-menu
