# Tutorial-07

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com,dlp.googleapis.com,bigquery.googleapis.com,bigquerystorage.googleapis.com,bigquerydatatransfer.googleapis.com,storage-component.googleapis.com,storage-api.googleapis.com"></walkthrough-enable-apis>

## Create A Bucket

```bash
gsutil mb -p {{project_id}} -c ARCHIVE -l asia-northeast1 -b on gs://{{project_id}}-bucket/
```

For more details, visit ([creating storage buckets](https://cloud.google.com/storage/docs/creating-buckets#storage-create-bucket-gsutil))

## Granting A Role To A Service Account

```bash
gcloud projects add-iam-policy-binding {{project_id}} --member serviceAccount:dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --role roles/storage.admin
```

<walkthrough-footnote>NOTE: with principle of least priviledge consideration, roles/storage.admin may not be appropriate</walkthrough-footnote>

## Export A Table

SSH login VM data-processor, and then run following command: 

```
bq --location=asia-northeast1 extract --destination_format CSV --compression GZIP --field_delimiter , --print_header=true {{project_id}}:dataset_ooo.table_xyz_deid gs://{{project_id}}-bucket/table-xyz-deid.csv.gzip
```

For more details, visit ([exporting table data](https://cloud.google.com/bigquery/docs/exporting-data))

Try following command to verify result:

```
gsutil cp gs://{{project_id}}-bucket/table-xyz-deid.csv.gzip .
```
```
file table-xyz-deid.csv.gzip
```
```
zcat table-xyz-deid.csv.gzip
```

## Clean Up

```bash
gcloud projects remove-iam-policy-binding  {{project_id}} --member serviceAccount:dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --role roles/storage.admin
```
```bash
gsutil rm -r gs://{{project_id}}-bucket
```
