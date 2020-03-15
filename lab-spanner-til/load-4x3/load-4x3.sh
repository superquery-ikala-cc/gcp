#!/bin/bash

set -e
 
echo "$(date) | CC | start load-4x3"

function generate() {
    sudo docker run --env-file config-02-v1.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-02:v1 generate
}
# generate

function create() {
    for case in 02 03
    do
        for version in v1 v2
        do
            sudo docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} create
        done
    done
}
# create

function load() {
    for case in 02 03
    do
        for version in v1 v2
        do
            sudo docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} reset

            for round in {1..3}
            do
                echo "$(date) | CC | start ${case}-${version} round ${round}"
                sudo docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} load
                echo "$(date) | CC | end ${case}-${version} round ${round}"
	        echo "$(date) | CC | sleeping 300s ..."
	        sleep 300
            done
        done
    done	    
}
# load

$0

echo "$(date) | CC | end load-4x3"
