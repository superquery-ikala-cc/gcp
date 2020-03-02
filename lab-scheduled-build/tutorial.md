# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="sourcerepo.googleapis.com,cloudbuild.googleapis.com,cloudscheduler.googleapis.com,appengine.googleapis.com,bigquery.googleapis.com"></walkthrough-enable-apis>

## Grant Permissions

```bash
project_number=$(gcloud projects describe gcp-expert-sandbox-jim --format='value(projectNumber)')
```
```bash
cloud_build_service_account=${project_number}@cloudbuild.gserviceaccount.com
```
```bash
gcloud projects add-iam-policy-binding {{project_id}} --member serviceAccount:${cloud_build_service_account} --role roles/bigquery.jobUser
```

## Prepare cloudbuild.yaml

e.g.,

```yaml
steps:
- name: 'gcr.io/cloud-builders/gcloud'
  entrypoint: 'bq'
  args:
  - query
  - --use_legacy_sql=false
  - 'SELECT 1'
```

## Create Repository

```bash
gcloud source repos create scheduled-build
```

## Init Repository

```bash
gcloud source repos clone scheduled-build
```
```bash
mkdir scheduled-build/select-1-job
```
```bash
cp cloudbuild.yaml scheduled-build/select-1-job/
```
```bash
cd scheduled-build/select-1-job/ && git add -A && git commit -m "init" && git push && cd -
```

## Create Trigger

```
gcloud beta builds triggers create cloud-source-repositories --repo="projects/{{project_id}}/repos/scheduled-build" --build-config="cloudbuild.yaml" --branch-pattern="^master$" --included-files="select-1-job/**" --description="select 1"
```

## Disable Trigger

## Create Job

```bash
trigger_id=$(gcloud beta builds triggers describe select-1-trigger --format='value(id)')
```
```bash
gcloud beta scheduler jobs create http scheduler-1 --schedule="*/5 * * * *" --uri=https://cloudbuild.googleapis.com/v1/projects/{{project_id}}/triggers/${trigger_id}:run --message-body='{"branchName":"master"}' --oauth-service-account-email={{project_id}}@appspot.gserviceaccount.com
```

## Clean Up

```bash
TODO
```
