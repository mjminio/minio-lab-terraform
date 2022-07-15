# Minio Labs Terraform

This repo deploys custom Minio Labs using Terraform.

This is in **ALPHA** and major changes will be made before it is ready for general consumption.

## Requirements
- Terraform installed on your local machine (https://learn.hashicorp.com/tutorials/terraform/install-cli)
- A cloud account and keys for:
  - AWS
  - DigitalOcean
  - Hetzner Cloud

## Components Deployed
- Ubuntu 20.04 Server(s)
- VSCode Server
- Various Minio deployment code

## IMPORTANT NOTICE
You will incur some cost as a result of deploying this to your cloud provider. Minio is not responsible for those costs.

Deployments are provided "AS-IS" with not guarantee on availability or complete functionality. These will be tested regularly, but ultimately you are responsible for deploying / maintaining / tearing down these systems.

## Install Instructions
- Make sure pre-requisites are complete
- Run `git clone https://github.com/mjminio/minio-lab-terraform.git`
- cd `minio-lab-terraform`
- Run `cp terraform.tfvars.dist terraform.tfvars`
- Update the following fields in the `terraform.tfvars` file
  - minio_password
  - code_server_password
  - Change the desired provider `_enabled` field to `1`
  - Change the `_count` on the desired cloud provider to `1`
  - Input your tokens/keys for the desired cloud provider
- Run `terraform init` and `terraform apply` and confirm that things look as expected. This will take approx 5 minutes before your server is ready. Be patient.
- To access the systems, open `files/minio-ui-links.txt` file to find access instructions for VSCode in the web browser
- Start Minio on your deployed server using the desired method. Do not run both at the same time, it will fail. Do either/or:
  - To deploy Minio using Docker, run `./files/start-minio-docker.sh`
  - To deploy Minio native, run `./files/start-minio-native.sh`

## Teardown Instructions
- In the `minio-lab-terraform` directory, run `terraform destroy`. This will remove all deployed components and no additional billing should be done once this command is run and the components are removed.

## About Minio

![Minio](assets/static/minio-logo.jpg)

MinIO offers high-performance, S3 compatible object storage.
Native to Kubernetes, MinIO is the only object storage suite available on every public cloud, every Kubernetes distribution, the private cloud and the edge. MinIO is software-defined and is 100% open source under GNU AGPL v3.

- **Website:** https://min.io/
- **Official Github:** https://github.com/minio