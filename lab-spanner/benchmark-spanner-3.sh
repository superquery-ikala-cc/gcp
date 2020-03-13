#!/bin/bash

set -e

function fn() {
    uuid32_1=$(python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)')
    uuid32_2=$(python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)')
    gcloud spanner databases execute-sql ${db} --sql="INSERT ${table} (uuid32) VALUES (${uuid32_1}),(${uuid32_2})"
}

for i in {1..300}
do
    time fn
    sleep 1
done
