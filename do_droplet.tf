resource "digitalocean_ssh_key" "minio_lab_key" {
  count      = "${var.do_enabled ? 1 : 0}"
  name       = "minio_lab_key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "do_init" {
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "digitalocean_droplet" "minio_lab_server" {
    count       = "${var.do_droplet_count > 0 ? var.do_droplet_count:0}"
    image       = var.do_os_type
    name        = "minio-do-server-${count.index}"
    region      = var.do_region
    size        = var.do_droplet_size
    ssh_keys = [digitalocean_ssh_key.minio_lab_key[0].id]
  user_data = "${data.template_file.do_init.rendered}"

  connection {
    type     = "ssh"
    user     = "${var.user}"
    private_key = tls_private_key.gen_ssh_key.private_key_pem
    host     = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/${var.user}/minio",
    ]
  }

  provisioner "file" {
  source      = "files/docker-compose.yml"
  destination = "/home/${var.user}/minio/docker-compose.yml"
  }

 provisioner "file" {
  source      = "assets/static/nginx.conf"
  destination = "/home/${var.user}/minio/nginx.conf"
  }
}
