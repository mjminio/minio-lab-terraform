## Deploys servers on DO

resource "digitalocean_ssh_key" "minio_lab_key" {
  count      = var.do_enabled ? 1 : 0
  name       = "${var.deployment_name}_minio_lab_key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "do_init" {
  count       = var.do_enabled ? 1 : 0
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "digitalocean_droplet" "minio_lab_server" {
  count       = var.do_enabled ? var.do_droplet_count : 0
  image       = var.do_os_type
  name        = "${var.deployment_name}-do-${count.index}"
  region      = var.do_region
  size        = var.do_droplet_size
  ssh_keys = [digitalocean_ssh_key.minio_lab_key[0].id]
  user_data = "${data.template_file.do_init[0].rendered}"
}
