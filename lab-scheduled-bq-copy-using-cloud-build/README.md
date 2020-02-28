
# Acknoledgement

Credit to https://polleyg.dev/posts/bigquery-scheduler-cloud-build/

# Key settings

1. cloud build service account `PROJECT_NUMBER@cloudbuild.gserviceaccount.com` of roles:
  * `BigQuery Data Viewer` on `source dataset`
  * `BigQuery Data Editor` on `destination dataset`
  * `BigQuery Job User` on `billing project` (with requester pays consideration, use source dataset project)
  * `BigQuery Connect User` on `source project`
  * `Storage Object Creator` on `bucket`
  * `Storage Object Viewer` on `bucket`
  * `Secret Manager Secret Accessor` on `secret`
2. service account used by cloud scheduler job of permission to invoke cloud build api e.g., `GAE SERVICE ACCOUNT`
3. trigger id
4. Enable APIs
  * App Engine (Cloud Scheduler 需要)
  * Cloud Scheduler
  * Cloud Build
  * Cloud Source Repository
  * BigQuery
  * Cloud Storage (儲存轉檔成功的戳記檔案)
  * Secret Manager (儲存 SendGrid API Key)
  * SendGrid

# Notes

Q1: cloud build timeout
A1: timeout (https://cloud.google.com/cloud-build/docs/api/reference/rest/v1/projects.builds) , default 10 minutes (can increase)

Q2: cloud scheduler timeout
A2: attempt_deadline (https://cloud.google.com/scheduler/docs/reference/rpc/google.cloud.scheduler.v1) , range 15 seconds and 30 minutes

Q3: idempotent
A3: ?

# Tutorial

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/home?cloudshell=true&cloudshell_git_repo=github.com/cclin81922/gcp.git&cloudshell_tutorial=lab-scheduled-bq-copy-using-cloud-build/tutorial.md)
