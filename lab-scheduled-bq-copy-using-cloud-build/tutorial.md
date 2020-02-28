# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="sourcerepo.googleapis.com,cloudbuild.googleapis.com,cloudscheduler.googleapis.com,bigquery.googleapis.com"></walkthrough-enable-apis>

## Grant Permissions

授與 cloud build service acccount 有 BQ 權限

```bash
project_number=$(gcloud projects describe gcp-expert-sandbox-jim --format='value(projectNumber)')
```
```bash
cloud_build_service_account=${project_number}@cloudbuild.gserviceaccount.com
```
```bash
gcloud projects add-iam-policy-binding {{project_id}} --member serviceAccount:${cloud_build_service_account} --role roles/bigquery.jobUser

# TODO
# 1. bq user of source dataset
# 2. bq user of destination dataset
```

選擇 cloud scheduler service account

## Step 0

建立一個 Cloud Storage Bucket

```bash
gsutil mb -b on -c standard -l asia-east1 -p {{project_id}} gs://{{project_id}}-cp-bq-table
```

## Step 1

編輯檔案 cloudbuild.yaml

## Step 2

建立一個 Cloud Source Repository

```bash
gcloud source repos create scheduled-bq-cp-using-cloud-build
```
## Step 3

初始化 Source Repository 的內容

```bash
gcloud source repos clone scheduled-bq-cp-using-cloud-build
```
```bash
cp cloudbuild.yaml scheduled-bq-cp-using-cloud-build
```
```bash
cd scheduled-bq-cp-using-cloud-build && git add -A && git commit -m "init" && git push && cd -
```

## Step 4

建立一個 Cloud Build Trigger

以下指令僅供參考，建議用 GCP Console 操作

```
gcloud beta builds triggers create cloud-source-repositories --repo="projects/{{project_id}}/repos/scheduled-bq-cp-using-cloud-build" --build-config="cloudbuild.yaml" --branch-pattern="^master$"
```

## Step 5

建立一個 Cloud Scheduler Job

```bash
trigger_id=$(gcloud beta builds triggers describe trigger-1 --format='value(id)')
```
```bash
gcloud beta scheduler jobs create http scheduler-1 --schedule="*/5 * * * *" --uri=https://cloudbuild.googleapis.com/v1/projects/{{project_id}}/triggers/${trigger_id}:run --message-body='{"branchName":"master"}' --oauth-service-account-email={{project_id}}@appspot.gserviceaccount.com
```

備註：{{project_id}}@appspot.gserviceaccount.com 可以考慮改用其他服務帳號

## Step 6

停用 Cloud Build Trigger 避免 Cloud Source Repository 異動觸發

用 GCP Console 操作，目前 gcloud 指令不支援這項操作

## Clean Up

```bash
TODO
```