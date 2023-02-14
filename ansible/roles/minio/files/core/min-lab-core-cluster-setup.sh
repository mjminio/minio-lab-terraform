#!/bin/bash

docker run -itd \
   -p 9050:9000 \
   -p 9051:9090 \
   --name minio1 \
   -v /mnt/data/minio1:/data \
   -e "MINIO_ROOT_USER=minioadmin" \
   -e "MINIO_ROOT_PASSWORD=minioadmin" \
   quay.io/minio/minio server /data --console-address ":9090"

docker run -itd \
   -p 9052:9000 \
   -p 9053:9090 \
   --name minio2 \
   -v /mnt/data/minio2:/data \
   -e "MINIO_ROOT_USER=minioadmin" \
   -e "MINIO_ROOT_PASSWORD=minioadmin" \
   quay.io/minio/minio server /data --console-address ":9090"

docker run -itd \
   -p 9054:9000 \
   -p 9055:9090 \
   --name minio3 \
   -v /mnt/data/minio3:/data \
   -e "MINIO_ROOT_USER=minioadmin" \
   -e "MINIO_ROOT_PASSWORD=minioadmin" \
   quay.io/minio/minio server /data --console-address ":9090"

   docker run -itd \
   -p 9056:9000 \
   -p 9057:9090 \
   --name minio4 \
   -v /mnt/data/minio4:/data \
   -e "MINIO_ROOT_USER=minioadmin" \
   -e "MINIO_ROOT_PASSWORD=minioadmin" \
   quay.io/minio/minio server /data --console-address ":9090"