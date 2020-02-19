# Tutorial-01

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com"></walkthrough-enable-apis>

## components

```bash
gcloud components list
```
常用命令列工具

* gcloud
* bq
* gsutil

## version

```bash
gcloud version
```

## info

```bash
gcloud info
```

## config

```bash
gcloud config configurations list
```

## auth

```bash
gcloud auth print-access-token
```

## projects

```bash
gcloud projects list
```

## services

```bash
gcloud services list
```

```bash
gcloud services list --enabled
```

```bash
gcloud services list --available
```

## init

```bash
gcloud init
```

## Available Command Groups

```bash
gcloud
```

## Curated Flags

* --log-http
* --verbosity=debug
* --impersonate-service-account=SERVICE_ACCOUNT_EMAIL
* --quiet, -q
* --format=FORMAT
* --project
* --region
* --zone

