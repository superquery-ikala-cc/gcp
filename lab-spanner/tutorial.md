# Tutorial

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Configuration

<walkthrough-watcher-constant key="spanner-instance" value="spanner-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-database" value="db-00"></walkthrough-watcher-constant>
<walkthrough-watcher-constant key="spanner-table" value="table_00"></walkthrough-watcher-constant>
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
```bash
gcloud config set spanner/instance {{spanner-instance}}
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
gcloud spanner instances create {{spanner-instance}} --description {{spanner-instance}} --config=regional-{{spanner-region}} --nodes={{spanner-node-count}}
```

### Database

```bash
gcloud spanner databases create {{spanner-database}}
```

### Table

```bash
gcloud spanner databases ddl update {{spanner-database}} --ddl='CREATE TABLE {{spanner-table}} (uuid32 STRING(32) NOT NULL) PRIMARY KEY (uuid32)'
```

## Generate Load 1

```bash
export db={{spanner-database}}
export table={{spanner-table}}
```
```bash
bash benchmark-spanner-1.sh
```

### Configuraiton

* method = rows insert
* sleep = 1s
* insert count = 300
* rows per insert = 1

### Monitoring Result

* **fn** avg time = 2~3s
* CPU utilization - high priority
  * All database high priority tasks: 1.06%
  * All instance high priority tasks: 1.06%
* CPU utilization - total
  * High-System = 0.61%
  * High-User = 0.45%
  * Low-System = 0.12%
  * Low-User = 0%
* Latency (write)
  * 50th percentile = 10ms
  * 90th percentile = 16ms
* Operation (write) per second = 0.25~0.3/s
* Throughput (write) = 50~55B/s
* Total storage ~ 0

## Generate Load 2

```bash
export db={{spanner-database}}
export table={{spanner-table}}
```
```bash
bash benchmark-spanner-2.sh
```

### Configuraiton

* method = databases execute-sql
* sleep = 1s
* insert count = 300
* rows per insert = 1

### Monitoring Result

* **fn** avg time = 1~1.5s
* CPU utilization - high priority
  * All database high priority tasks: 2.93%
  * All instance high priority tasks: 2.93%
* CPU utilization - total
  * High-System = 1.21%
  * High-User = 1.72%
  * Low-System = 0.07%
  * Low-User = 0%
* Latency (write)
  * 50th percentile = 12ms
  * 90th percentile = 16ms
* Operation (write) per second = 0.4~0.45/s
* Throughput (write) = 80B/s
* Total storage ~ 0

---

* Latency (read)
  * 50th percentile = 14ms
  * 90th percentile = 32ms
* Operation (read) per second = 0.4~0.45/s
* Throughput (read) = 20B/s

## Generate Load 3

```bash
export db={{spanner-database}}
export table={{spanner-table}}
```
```bash
bash benchmark-spanner-3.sh
```

### Configuraiton

* method = databases execute-sql
* sleep = 1s
* insert count = 300
* rows per insert = 2

### Monitoring Result

* **fn** avg time = 1~1.8s
* CPU utilization - high priority
  * All database high priority tasks: ?%
  * All instance high priority tasks: ?%
* CPU utilization - total
  * High-System = ?%
  * High-User = ?%
  * Low-System = ?%
  * Low-User = 0%
* Latency (write)
  * 50th percentile = ?ms
  * 90th percentile = ?ms
* Operation (write) per second = ?/s
* Throughput (write) = ?B/s
* Total storage ~ 0

## Clean Up

```bash
TODO
```
