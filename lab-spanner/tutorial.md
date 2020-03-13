# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="spanner-instance" value="spanner-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-database" value="db-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-table" value="table-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-primkey" value="uuid32"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-region" value="asia-east1"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-replica-count" value="3"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-node-count" value="1"></walkthrough-watcher-constant>

spanner-instance = {{spanner-instance}}

spanner-database = {{spanner-database}}

spanner-table = {{spanner-table}}

spanner-primkey = {{spanner-primkey}}

spanner-region = {{spanner-region}}

spanner-replica-count = {{spanner-replica-count}}

spanner-node-count = {{spanner-node-count}}

## Setup Project

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

<walkthrough-enable-apis apis="spanner.googleapis.com"></walkthrough-enable-apis>

## Create Accounts

None

## Grant Permissions

None

## Create Spanner

### Instance

```bash
```

### Database

```bash
```

### Table

```bash
```

## Generate Load

```bash
```

### Result

## Clean Up

```bash
TODO
```
