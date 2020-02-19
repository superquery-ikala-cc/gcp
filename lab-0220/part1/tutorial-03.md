# Tutorial-03

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="cloudresourcemanager.googleapis.com"></walkthrough-enable-apis>

## Google API Client Libraries

```bash
virtualenv ~/g-api
```
```bash
source ~/g-api/bin/activate
```
```bash
pip install --upgrade google-api-python-client
```
```bash
python
```
```bash
import googleapiclient.discovery
```
```bash
resourcemanager = googleapiclient.discovery.build('cloudresourcemanager', 'v1')
```
```bash
resourcemanager.projects().list().execute()
```
```bash
quit()
```

## Google Cloud Client Libraries

[Available libraries](https://github.com/googleapis/google-cloud-python#google-cloud-python-client)

```bash
virtualenv ~/g-api
```
```bash
source ~/g-api/bin/activate
```

### e.g., Google Cloud Storage

```bash
pip install --upgrade google-cloud-storage
```
```bash
python
```
```bash
from google.cloud import storage
```
```bash
client = storage.Client()
```
```bash
quit()
```

### e.g., Google BigQuery

```bash
pip install --upgrade google-cloud-bigquery
```
```bash
python
```
```bash
from google.cloud import bigquery
```
```bash
client = bigquery.Client()
```
```bash
quit()
```

## Application Credentials

### Method 2

```
export GOOGLE_APPLICATION_CREDENTIALS='/path/to/service-account-key-file.json'
```

### Method 3

[Available scopes](https://developers.google.com/identity/protocols/googlescopes)

```
from google.oauth2 import service_account
SCOPES = ['https://www.googleapis.com/auth/cloud-platform']
SERVICE_ACCOUNT_FILE = '/path/to/service-account-key-file.json'
credentials = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
```
```
resourcemanager = googleapiclient.discovery.build('cloudresourcemanager', 'v1', credentials=credentials)
```
```
client = storage.Client(credentials=credentials)
```
```
client = bigquery.Client(credentials=credentials)
```

<walkthrough-footnote>NOTE: with principle of least priviledge consideration, https://www.googleapis.com/auth/cloud-platform may not be appropriate</walkthrough-footnote>
