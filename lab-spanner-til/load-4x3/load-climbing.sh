#!/bin/bash

set -e
 
echo "$(date) | CC | start load-climbing"

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
    for case in 02
    do
        for version in v1
        do
            for ccu in 10 20 40 80 160
            do
                echo "$(date) | CC | reset ${case}-${version}"
                sudo docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} reset
		echo "$(date) | CC | sleep 60s ..."
		sleep 60

                echo "$(date) | CC | start ${case}-${version} ccu ${ccu}"
                sudo docker run --env-file config-${case}-${version}.env -it gcr.io/gcp-expert-sandbox-jim/til-about-cloudspanner-${case}:${version} load
                echo "$(date) | CC | end ${case}-${version} ccu ${ccu}"
	        echo "$(date) | CC | sleep 240s ..."
	        sleep 240
            done
        done
    done	    
}
# load

$1

echo "$(date) | CC | end load-climbing"
