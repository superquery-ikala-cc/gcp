#!/bin/bash

set -e

for case in 02:v1 02:v2 03:v1 03:v2
do
    for round in {1..3}
    do
        echo "$(date) | CC | ${case} round ${round}"
        docker run --env-file config.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case} load
        docker run --env-file config.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case} reset
	sleep 300
    done
done
