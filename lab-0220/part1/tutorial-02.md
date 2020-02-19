# Tutorial-02

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

Click the **Start** button to move to the next step.

## Select A Project

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>NOTE: need owner permission</walkthrough-footnote>

## Enable APIs

<walkthrough-enable-apis apis="cloudresourcemanager.googleapis.com"></walkthrough-enable-apis>

## APIs Explorer

Open [APIs EXplorer](https://developers.google.com/apis-explorer)

Search **`Cloud Resource Manager API`**

Select **`Cloud Resource Manager API`**

Select **`v1`**

Select **`projects`**

Select **`list`**

Click **`EXECUTE`**

Select an user account

Click **`Allow`**

Take a look at the **`HTTP request`**

Use following **`curl`** command to execute this API

```bash
curl -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)" https://cloudresourcemanager.googleapis.com/v1/projects
```
