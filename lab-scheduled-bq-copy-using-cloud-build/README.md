
# Acknoledgement

Credit to https://polleyg.dev/posts/bigquery-scheduler-cloud-build/

# Key settings

1. service account used by cloud build     (of permission to call bigquery api)
2. service account used by cloud scheduler (of permission to call cloud build api)
3. project number
4. project id
5. trigger id

Draft

Step 1

```
gcloud source repos create scheduled-bq-cp-using-cloud-build
```

Step 2

```
gcloud source repos clone scheduled-bq-cp-using-cloud-build
cp cloudbuild.yaml scheduled-bq-cp-using-cloud-build
cd scheduled-bq-cp-using-cloud-build && git add -A && git commit -m "init" && git push && cd -
```

Step 3

```
gcloud beta builds triggers create cloud-source-repositories --repo="projects/gcp-expert-sandbox-jim/repos/scheduled-bq-cp-using-cloud-build" --build-config="cloudbuild.yaml" --branch-pattern="^master$"
```

Step 4

```
gcloud projects add-iam-policy-binding {{project_id}} --member serviceAccount:{{project_number}}@cloudbuild.gserviceaccount.com --role roles/bigquery.jobUser
```

Step 5

```
gcloud beta scheduler jobs create http scheduler-1 --schedule="*/5 * * * *" --uri=https://cloudbuild.googleapis.com/v1/projects/gcp-expert-sandbox-jim/triggers/2eef9ae9-cb9f-4d6d-a614-9515e9bb98df:run --message-body='{"branchName":"master"}' --oauth-service-account-email=gcp-expert-sandbox-jim@appspot.gserviceaccount.com
```

Step 6

```
# With GCP Console, disable the cloud build trigger so that it will not be triggered by git repo changes
```
