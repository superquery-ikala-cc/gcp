# Tutorial-09

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com,dlp.googleapis.com,bigquery.googleapis.com,bigquerystorage.googleapis.com,bigquerydatatransfer.googleapis.com,storage-component.googleapis.com,storage-api.googleapis.com"></walkthrough-enable-apis>

## Day 2 Operation

SSH login VM data-processor, and then run following command: 

```
cat > table-xyz-20200102.csv <<DATA
name,birth_date,register_date,credit_card
Ann,01/01/1970,07/21/1996,4532908762519852
James,03/06/1988,04/09/2001,4301261899725540
Dan,08/14/1945,11/15/2011,4620761856015295
Laura,11/03/1992,01/04/2017,4564981067258901
DATA
```
```
cd python-docs-samples/dlp
```
```
python deid.py deid_date_shift {{project_id}} ~/table-xyz-20200102.csv ~/table-xyz-20200102-deid.csv -100 100 birth_date
```
```
bq --location=asia-east1 load --autodetect --source_format=CSV {{project_id}}:youbike_dataset.table_xyz_deid ~/table-xyz-20200102-deid.csv
```
```
bq query --use_legacy_sql=false 'SELECT * FROM `{{project_id}}.youbike_dataset.table_xyz_deid`'
```

## Create A Cron Job

SSH login VM data-processor, and then run following command:

```
crontab -e
```

Choose an text editor

At the bottom, add the code for your cron job.

`* 3 * * * bash daily-job.sh`

Save and exit text editor

Create the file `daily-job.sh`

```
cat > daily-job.sh <<SCRIPT
id=\$(( \$(ls table-xyz-????????.csv | wc -l) + 1 ))

cat > table-xyz-2020010\${id}.csv <<DATA
name,birth_date,register_date,credit_card
Ann,01/01/1970,07/21/1996,4532908762519852
James,03/06/1988,04/09/2001,4301261899725540
Dan,08/14/1945,11/15/2011,4620761856015295
Laura,11/03/1992,01/04/2017,4564981067258901
DATA

cd python-docs-samples/dlp

python deid.py deid_date_shift gcp-expert-sandbox-jim ~/table-xyz-2020010\${id}.csv ~/table-xyz-2020010\${id}-deid.csv -100 100 birth_date

bq --location=asia-east1 load --autodetect --source_format=CSV gcp-expert-sandbox-jim:youbike_dataset.table_xyz_deid ~/table-xyz-2020010\${id}-deid.csv
SCRIPT
```

Try run `daily-job.sh`

```
bash daily-job.sh
```
```
bq query --use_legacy_sql=false 'SELECT * FROM `gcp-expert-sandbox-jim.youbike_dataset.table_xyz_deid`'
```

(optional) Change crob job to `* * * * *` then use command `watch -n 60 'ls'` to see what will happend
