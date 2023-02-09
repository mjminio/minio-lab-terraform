#!/bin/bash

HOST=$(hostname)
echo $HOST

echo "changing dir"
cd /home/minio/minio/labs

echo "updating repo"
git fetch origin main && git reset --hard origin/main

echo "updating occurences of LABSERVERNAME"
find /home/minio/minio/labs -type f -exec sed -i "s/LABSERVERNAME/${HOST}/g" {} \;
