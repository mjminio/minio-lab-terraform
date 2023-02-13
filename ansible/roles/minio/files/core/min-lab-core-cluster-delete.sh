#!/bin/bash

CURRENTTIME=`date +"%Y%m%d%H%M%S"`
sudo mkdir -p /mnt/.backup/$CURRENTTIME
sudo cp -R /mnt/data/* /mnt/.backup/$CURRENTTIME

docker rm -f minio1
sudo rm -rf /mnt/data/minio1
docker rm -f minio2
sudo rm -rf /mnt/data/minio2
docker rm -f minio3
sudo rm -rf /mnt/data/minio3
docker rm -f minio4
sudo rm -rf /mnt/data/minio4