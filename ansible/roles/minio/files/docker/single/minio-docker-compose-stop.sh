#!/bin/bash

/home/ubuntu/.local/bin/podman-compose -f /home/{{ user }}/minio/tools/deploy/docker/docker-compose/single/docker-compose.yml down -v