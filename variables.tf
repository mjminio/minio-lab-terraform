# General User variables
variable "deployment_name" {}
variable "user" {}
variable "environment_domain" {}
variable "letsencrypt_email" {}
variable "minio_password" {}
variable "code_server_password" {}
variable "haproxy_password" {}
variable "shutdown_after_time" {}

# Github
variable "gh_pat" {}

# Hetzner (hcloud) variables
variable "hcloud_enabled" {}
variable "hcloud_token" {}
variable "hcloud_server_count" {default = "1"}
variable "hcloud_location" {default = "ash"}
variable "hcloud_server_type" {default = "cpx31"}
variable "hcloud_os_type" {default = "ubuntu-23.04"}

# DigitalOcean (DO) variables
variable "do_enabled" {}
variable "do_token" {}
variable "do_droplet_count" {default = "1"}
variable "do_region" {}
variable "do_droplet_size" {default = "s-4vcpu-8gb"}
variable "do_os_type" {default = "ubuntu-23-04-x64"}

# vm-broker (vm_broker) variables
variable "vm_broker_enabled" {}
variable "vm_broker_token" {}
variable "vm_broker_server_count" {default = "1"}
variable "vm_broker_os_type" {default = "ubuntu-23.04"}

# AWS Access Info
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_rt53_zone_id" {}

# AWS variables
variable "aws_enabled" {}
variable "aws_region" {}
variable "aws_instance_count" {}
variable "aws_instance_image" {}
variable "aws_instance_size" {}

# DNS Options
variable "dns_service" {}

#Cloudflare variables
variable "cloudflare_email" {}
variable "cloudflare_api_token" {}
variable "cloudflare_zone_id" {}

variable "environment_systemd_directory" {}
variable "docker_compose_version" {}
variable "code_server_version" {}
variable "lab_repo_url" {}
variable "codelab_version" {
    default = "0.0.4"
}