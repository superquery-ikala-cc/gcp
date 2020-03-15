#!/bin/bash

set -e

for case in 02 03
do
    for version in v1 v2
    do
        for round in {1..3}
        do
            echo "$(date) | CC | ${case}-${version} round ${round}"
            docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} load
            docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} reset
	    sleep 300
        done
    done
done
