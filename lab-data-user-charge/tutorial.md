# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="bucket-name" value="data-user-pay-bucket"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="dataset-name" value="data_user_pay_dataset"></walkthrough-watcher-constant>
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
gsutil -u {{project-id}} cat gs://{{bucket-name}}/1GB.txt
```

### BQ

```
bq query --use_legacy_sql=false 'SELECT * FROM {{data-owner-project}}.{{dataset-name}}.commits'
```

### SKU

TODO

### LOG

TODO

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

## Create Bucket Y

```bash
gsutil mb -c STANDARD -l asia-east1 -b on gs://{{bucket-name}}/
```

### Create Object

```bash
dd if=/dev/zero of=/tmp/1GB.txt bs=1024 count=1048576
```
```bash
gsutil cp /tmp/1GB.txt gs://{{bucket-name}}/1GB.txt
```

### Grant Permission

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **Storage** section.

<walkthrough-menu-navigation sectionId="STORAGE_SECTION"></walkthrough-menu-navigation>

Then, select the **{{bucket-name}}** bucket.

Then, select the [Permissions][spotlight-permissions] tab.

[spotlight-permissions]: walkthrough://spotlight-pointer?cssSelector=[g-tab-value=permissions]

Then, select the [Add members][spotlight-add-members] button.

[spotlight-add-members]: walkthrough://spotlight-pointer?cssSelector=jfk-button.p6n-open-add-member

Then, add the **{{data-user-account}}@{{data-user-project}}.iam.gserviceaccount.com** member.

Then, select the **Storage Object Viewer** role.

### Enable Requester Pay

```bash
gsutil requesterpays set on gs://{{bucket-name}}
```

### Enable Data Access Audit Log

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **IAM & Admin** section.

<walkthrough-menu-navigation sectionId="IAM_ADMIN_SECTION"></walkthrough-menu-navigation>

Then, select the [Audit Logs][spotlight-audit-logs] menu.

Then, select the **Google Cloud Storage** service.

Then, enable the **Data Read** log.

[spotlight-audit-logs]: walkthrough://spotlight-pointer?cssSelector=[id=cfctest-section-nav-item-audit]

TODO: ADD MORE INSTRUCTIONS

## Create Dataset

```bash
bq --location=us mk --dataset --default_table_expiration 0 --default_partition_expiration 31536000 {{project-id}}:{{dataset-name}}
```

### Create Table

```txt
bq query --location us --replace --destination_table {{project-id}}:{{dataset-name}}.commits --use_legacy_sql=false 'SELECT * FROM `bigquery-public-data.github_repos.commits`'
```

### Grant Permission

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **BigQuery** section.

<walkthrough-menu-navigation sectionId="BIGQUERY_SECTION"></walkthrough-menu-navigation>

Then, select the **{{dataset-name}}** dataset.

Then, select the [SHARE DATASET][spotlight-share-dataset] button.

[spotlight-share-dataset]: walkthrough://spotlight-pointer?cssSelector=.p6n-bq-test-share-dataset-button

Then, add the **{{data-user-account}}@{{data-user-project}}.iam.gserviceaccount.com** member.

Then, select the **BigQuery Data Viewer** role.

## Clean Up

```bash
TODO
```

[spotlight-console-menu]: walkthrough://spotlight-pointer?spotlightId=console-nav-menu
