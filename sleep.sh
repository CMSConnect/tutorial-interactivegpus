#! /bin/bash

time=$1
echo "Execute singularity wrapper to enter tensorflow container"
echo "./singularity_wrapper.sh bash"
sleep $((time*60))
