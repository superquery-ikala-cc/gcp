# Tutorial-06

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com,dlp.googleapis.com,bigquery.googleapis.com,bigquerystorage.googleapis.com,bigquerydatatransfer.googleapis.com"></walkthrough-enable-apis>

## Create A Dataset

```bash
bq --location=asia-northeast1 mk --dataset --default_table_expiration 0 --default_partition_expiration 31536000 {{project_id}}:dataset_ooo
```

For more details, visit ([creating datasets](https://cloud.google.com/bigquery/docs/datasets#bigquery-create-dataset-cli))

## Granting A Role To A Service Account

```bash
gcloud projects add-iam-policy-binding {{project_id}} --member serviceAccount:dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --role roles/bigquery.admin
```

<walkthrough-footnote>NOTE: with principle of least priviledge consideration, roles/bigquery.admin may not be appropriate</walkthrough-footnote>

## Load A CSV File

SSH login VM data-processor, and then run following command: 

```
bq --location=asia-northeast1 load --autodetect --source_format=CSV {{project_id}}:dataset_ooo.table_xyz_deid ~/table-xyz-20200101-deid.csv
```

For more details, visit ([loading data from a local file](https://cloud.google.com/bigquery/docs/loading-data-local))

Try following command to query data:

```
bq query --use_legacy_sql=false 'SELECT * FROM `{{project_id}}.dataset_ooo.table_xyz_deid`'
```

<walkthrough-footnote>NOTE: with best practices, you should avoid select * in the query</walkthrough-footnote>

## Clean Up

```bash
gcloud projects remove-iam-policy-binding  {{project_id}} --member serviceAccount:dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --role roles/bigquery.admin
```
```bash
bq rm -r -d {{project_id}}:dataset_ooo
```
