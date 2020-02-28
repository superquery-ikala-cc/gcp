## Main Menu

### Navigate to App Engine

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **App Engine** section.

<walkthrough-menu-navigation sectionId="APPENGINE_SECTION"></walkthrough-menu-navigation>

### Navigate to Compute Engine

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **Compute Engine** section.

<walkthrough-menu-navigation sectionId="COMPUTE_SECTION"></walkthrough-menu-navigation>

### Navigate to Kubernetes Engine

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **Kubernetes Engine** section.

<walkthrough-menu-navigation sectionId="KUBERNETES_SECTION"></walkthrough-menu-navigation>

### Navigate to Cloud Functions

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **Cloud Functions** section.

<walkthrough-menu-navigation sectionId="FUNCTIONS_SECTION"></walkthrough-menu-navigation>

### Navigate to Cloud Run

Open the [menu][spotlight-console-menu] on the left side of the console.

Then, select the **Cloud Run** section.

<walkthrough-menu-navigation sectionId="SERVERLESS_SECTION"></walkthrough-menu-navigation>

<walkthrough-footnote>NOTE: inspect and find css class of prefix cfc-console-nav-section-</walkthrough-footnote>


## Button Textbox List

### Compute Engine

Click the [Create instance][spotlight-create-instance] button.

[spotlight-create-instance]: walkthrough://spotlight-pointer?spotlightId=gce-zero-new-vm,gce-vm-list-new

<walkthrough-footnote>NOTE: inspect and find attribute instrumentation-id</walkthrough-footnote>

### Kubernetes Engine

Click the [Create cluster][spotlight-create-cluster] button.

[spotlight-create-cluster]: walkthrough://spotlight-pointer?cssSelector=.p6n-zero-state-link-test.jfk-button-primary,gce-create-button

<walkthrough-footnote>NOTE: inspect and find css class attribute</walkthrough-footnote>

### Cloud Functions

Click the [Create function][spotlight-create-function] button.

[spotlight-create-function]: walkthrough://spotlight-pointer?spotlightId=gcf-list-new

<walkthrough-footnote>NOTE: inspect and find attribute instrumentationid</walkthrough-footnote>

### Cloud Run

Click the [Create service][spotlight-create-service] button.

[spotlight-create-service]: walkthrough://spotlight-pointer?cssSelector=.ace-icon.ace-icon-create.ace-icon-size-small

<walkthrough-footnote>NOTE: inspect and find attribute instrumentation-id, but not works</walkthrough-footnote>
<walkthrough-footnote>NOTE: inspect and find css class attribute, and it works</walkthrough-footnote>

## Open Cloud Shell

The **gcloud** CLI is used to interface with the instance. This tool comes
pre-installed in the web console shell.

Open Cloud Shell by clicking
<walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon>
[icon][spotlight-open-devshell] in the navigation bar at the top of the
console.

[spotlight-open-devshell]: walkthrough://spotlight-pointer?spotlightId=devshell-activate-button

Use this command to connect to the instance:

```bash
gcloud sql connect InstanceIdHere --user=root
```

You should see a prompt similar to the following:

```terminal
MySQL [(none)]
```

## SQL

Within the `MySQL` prompt, run the following:

1.  Create database and table

    ```sql
    CREATE DATABASE geography;
    USE geography;
    CREATE TABLE cities (city VARCHAR(255), country VARCHAR(255));
    ```

1.  Insert data

    ```sql
    /* Insert dummy data into 'cities' table */
    INSERT INTO cities (city, country) values ("San Francisco", "USA");
    INSERT INTO cities (city, country) values ("Beijing", "China");
    ```

1.  Query

    ```sql
    SELECT * FROM cities;
    ```

    You should see the following query results:

    ```terminal
    SELECT * FROM cities;
    +---------------+---------+

    +---------------+---------+

    +---------------+---------+

## Python

```python
import os
```
