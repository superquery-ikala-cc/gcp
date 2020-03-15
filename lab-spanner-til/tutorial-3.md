# Tutorial

## Introduction

03-maximizing-data-load-throughput/version01

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="spanner-instance" value="spanner-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-database" value="db-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-region" value="asia-east1"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-node-count" value="3"></walkthrough-watcher-constant>

spanner-instance = {{spanner-instance}}

spanner-database = {{spanner-database}}

spanner-region = {{spanner-region}}

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
```bash
gcloud config set spanner/instance {{spanner-instance}}
```

### gsutil

None

### bq

None


## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,storage-api.googleapis.com,storage-component.googleapis.com,spanner.googleapis.com,containerregistry.googleapis.com"></walkthrough-enable-apis>

## Create Accounts

None

## Grant Permissions

None

## Create VM

```bash
gcloud compute instances create til-about-cloudspanner --machine-type n1-highcpu-16 --scopes "https://www.googleapis.com/auth/cloud-platform" --image-project ubuntu-os-cloud --image-family ubuntu-1804-lts
```

### Download sample code

```
git clone https://github.com/hostirosti/til-about-cloudspanner
cd til-about-cloudspanner/03-maximizing-data-load-throughput/version01/golang
```

### Build code

```
sudo docker build -t gcr.io/{{project-id}}/til-about-cloudspanner-03:v1 --build-arg version=v1 .
```

### Copy and adjust the configuration file

```
cp config-sample.env config.env
# EDIT config.env
```

e.g.,

```txt
PROJECT={{project-id}}
INSTANCE={{spanner-instance}}
DATABASE={{spanner-database}}
BUCKET={{project-id}}-til-about-cloudspanner
FOLDERPATH=03-maximizing-data-load-throughput/version01
```

## Generate Sample Data

```bash
gsutil mb -l asia-east1 gs://{{project-id}}-til-about-cloudspanner
```
```
sudo docker run --env-file config.env -it gcr.io/{{project-id}}/til-about-cloudspanner-03:v1 generate
```

## Create Spanner

```bash
gcloud spanner instances create {{spanner-instance}} --config regional-{{spanner-region}} --description "TIL about Cloud Spanner" --nodes {{spanner-node-count}}
```

### Create Database and Table

```
docker run --env-file config.env -it gcr.io/{{project-id}}/til-about-cloudspanner-03:v1 create
```

## Load Test

```
docker run --env-file config.env -it gcr.io/{{project-id}}/til-about-cloudspanner-03:v1 load
```

## Reset Spanner

```
docker run --env-file config.env -it gcr.io/{{project-id}}/til-about-cloudspanner-03:v1 reset
```

## Clean Up

```bash
TODO
```
