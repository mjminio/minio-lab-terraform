#!/bin/bash

/home/ubuntu/.local/bin/podman-compose -f /home/{{ user }}/minio/tools/deploy/docker/docker-compose/distributed/docker-compose.yml up -d