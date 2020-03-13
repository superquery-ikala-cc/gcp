#!/bin/bash

set -e

function fn() {
    uuid32=$(python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)')
    gcloud spanner databases execute-sql ${db} --sql="INSERT {{table}} (uuid32) VALUES (${uuid32})"
}

for i in {1..300}
do
    time fn
    sleep 1
done
