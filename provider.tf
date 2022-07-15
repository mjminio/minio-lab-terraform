# Configure the Hetzner Cloud Provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.33.1"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "hcloud" {
  token   = var.hcloud_token
}

provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}