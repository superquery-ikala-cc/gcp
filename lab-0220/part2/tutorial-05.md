# Tutorial-05

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com,dlp.googleapis.com"></walkthrough-enable-apis>

## Granting A Role To A Service Account

```bash
gcloud projects add-iam-policy-binding {{project_id}} --member serviceAccount:dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --role roles/dlp.admin
```

<walkthrough-footnote>NOTE: with principle of least priviledge consideration, roles/dlp.admin may not be appropriate</walkthrough-footnote>

## De-identify A CSV File

SSH login VM data-processor, and then run following command: 

```
sudo apt install git python-pip -y
```
```
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
```
```
cd python-docs-samples/dlp
```
```
pip install -r requirements.txt
```
```
python deid.py deid_date_shift {{project_id}} ~/table-xyz-20200101.csv ~/table-xyz-20200101-deid.csv -100 100 birth_date
```

Try following command to verify result:

```
diff ~/table-xyz-20200101.csv ~/table-xyz-20200101-deid.csv
```

For more details, visit ([date shifting concept](https://cloud.google.com/dlp/docs/concepts-date-shifting)) ([date shifting with python](https://cloud.google.com/dlp/docs/deidentify-sensitive-data#dlp-deidentify-date-shift-python)) ([github](https://github.com/GoogleCloudPlatform/python-docs-samples/tree/master/dlp))

## Clean Up

```bash
gcloud projects remove-iam-policy-binding  {{project_id}} --member serviceAccount:dlp-gcs-bq@{{project_id}}.iam.gserviceaccount.com --role roles/dlp.admin
```
