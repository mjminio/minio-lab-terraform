# General User variables
variable "deployment_name" {}
variable "user" {}
variable "minio_password" {}
variable "code_server_password" {}
variable "shutdown_after_time" {}

# Hetzner (hcloud) variables
variable "hcloud_enabled" {}
variable "hcloud_token" {}
variable "hcloud_server_count" {default = "1"}
variable "hcloud_location" {default = "ash"}
variable "hcloud_server_type" {default = "cpx31"}
variable "hcloud_os_type" {default = "ubuntu-20.04"}

# DigitalOcean (DO) variables
variable "do_enabled" {}
variable "do_token" {}
variable "do_droplet_count" {default = "1"}
variable "do_region" {}
variable "do_droplet_size" {default = "s-4vcpu-8gb"}
variable "do_os_type" {default = "ubuntu-20-04-x64"}

# AWS variables
variable "aws_enabled" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "aws_instance_count" {}
variable "aws_instance_image" {}
variable "aws_instance_size" {}

variable "environment_systemd_directory" {}
variable "docker_compose_version" {}
variable "code_server_version" {}
variable "lab_repo_url" {}