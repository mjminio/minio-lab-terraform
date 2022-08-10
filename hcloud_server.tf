## Deploys servers on Hetzner Cloud

resource "hcloud_ssh_key" "minio_lab_key" {
  count       = var.hcloud_enabled ? 1 : 0
  name       = "${var.deployment_name}_minio_lab_key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "hcloud_init" {
  count       = var.hcloud_enabled ? 1 : 0
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "hcloud_server" "minio_lab_server" {
  count       = var.hcloud_enabled ? var.hcloud_server_count : 0
  name        = "${var.deployment_name}-minio-hcloud-${count.index}"
  image       = var.hcloud_os_type
  server_type = var.hcloud_server_type
  location    = var.hcloud_location
  ssh_keys    = [hcloud_ssh_key.minio_lab_key[0].id]
  labels = {
    type = "minio"
  }
  user_data = "${data.template_file.hcloud_init[0].rendered}"
}

