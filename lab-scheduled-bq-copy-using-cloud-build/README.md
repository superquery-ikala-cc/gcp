
# Acknoledgement

Credit to https://polleyg.dev/posts/bigquery-scheduler-cloud-build/

# Key settings

1. service account used by cloud build     (of permission to call bigquery api)
2. service account used by cloud scheduler (of permission to call cloud build api)
3. trigger id

# Questions

Q1: cloud build timeout
A1: 10 minutes (can increase)

Q2: cloud scheduler timeout
A2: ?

Q3: idempotent
A3: ?


# Tutorial

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/home?cloudshell=true&cloudshell_git_repo=github.com/cclin81922/gcp.git&cloudshell_tutorial=lab-scheduled-bq-copy-using-cloud-build/tutorial.md)
