# Tutorial-04

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com"></walkthrough-enable-apis>

## Create A Service Account

```bash
gcloud iam service-accounts create dlp-gcs-bq
```

## Create A Server

```bash
gcloud compute instances create data-processor --network=cloud-net --subnet=cloud-db-subnet --zone=asia-northeast1-a --service-account=dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --scopes=cloud-platform
```

## Setup Firewall

```bash
gcloud compute firewall-rules create cloud-fw-data-processor-rule --network=cloud-net --allow=all --source-ranges=192.168.200.0/24
```

## Create A CSV File

SSH login VM data-processor, and then run following command: 

```
cat > table-xyz-20200101.csv <<DATA
name,birth_date,register_date,credit_card
Ann,01/01/1970,07/21/1996,4532908762519852
James,03/06/1988,04/09/2001,4301261899725540
Dan,08/14/1945,11/15/2011,4620761856015295
Laura,11/03/1992,01/04/2017,4564981067258901
DATA
```

## Clean Up

```bash
gcloud compute firewall-rules delete cloud-fw-data-processor-rule
```
```bash
gcloud compute instances delete data-processor --zone=asia-east1-a
```
```bash
gcloud iam service-accounts delete dlp-gcs-bq
```
