# Tutorial-08

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com,dlp.googleapis.com,bigquery.googleapis.com,bigquerystorage.googleapis.com,bigquerydatatransfer.googleapis.com,storage-component.googleapis.com,storage-api.googleapis.com"></walkthrough-enable-apis>

## Upload A CSV File

SSH login VM data-processor, and then run following command: 

```
gsutil cp table-xyz-20200101.csv gs://{{project_id}}-youbike-bucket/table-xyz-20200101.csv
```

For more details, visit ([uploading objects](https://cloud.google.com/storage/docs/uploading-objects))

Try following command to verify result:

```
gsutil cat gs://{{project_id}}-youbike-bucket/table-xyz-20200101.csv
```
