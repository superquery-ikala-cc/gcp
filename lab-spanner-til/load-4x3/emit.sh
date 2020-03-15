#!/bin/bash

while read -r line
do
    echo $line
    gcloud logging write load-4x3-log "${line}" --severity=INFO
done
