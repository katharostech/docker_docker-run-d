#!/bin/bash

# Start container
mkdir -p /rund/docker-run-d
docker run -d $@ > /container_id


# Trap SIGTERM
trap 'docker stop $(cat /container_id) && docker rm $(cat /container_id) && exit 0' SIGTERM SIGINT

# Wait for signal
while true; do :; done
