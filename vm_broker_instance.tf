## Deploys servers on vm-broker

resource "vm_broker_ssh_key" "minio_lab_key" {
  count       = var.vm_broker_enabled ? 1 : 0
  name       = "${var.deployment_name}_minio_lab_key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "vm_broker_init" {
  count       = var.vm_broker_enabled ? 1 : 0
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "vm_broker_instance" "minio_lab_server" {
  count       = var.vm_broker_enabled ? var.vm_broker_server_count : 0
  name        = "${var.deployment_name}-vm-broker-${count.index + 1}"
  image       = var.vm_broker_os_type
  server_type = var.vm_broker_server_type
  location    = var.vm_broker_location
  ssh_keys    = [vm_broker_ssh_key.minio_lab_key[0].id]
  labels = {
    type = "minio"
  }
  user_data = "${data.template_file.vm_broker_init[0].rendered}"
}

