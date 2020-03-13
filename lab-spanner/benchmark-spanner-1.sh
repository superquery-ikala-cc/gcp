#!/bin/bash

set -e

function fn() {
    uuid32=$(python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)')
    gcloud spanner rows insert --database=${db} --table=${table} --data=uuid32=${uuid32}
}

for i in {1..300}
do
    time fn
    sleep 1
done
