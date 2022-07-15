## Deploys servers on Hetzner Cloud

resource "hcloud_ssh_key" "minio_lab_key" {
  count      = "${var.hcloud_enabled ? 1 : 0}"
  name       = "minio_lab_key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "hcloud_init" {
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "hcloud_server" "minio_lab_server" {
  count       = var.hcloud_server_count
  name        = "minio-hcloud-server-${count.index}"
  image       = var.hcloud_os_type
  server_type = var.hcloud_server_type
  location    = var.hcloud_location
  ssh_keys    = [hcloud_ssh_key.minio_lab_key[0].id]
  labels = {
    type = "minio"
  }
  user_data = "${data.template_file.hcloud_init.rendered}"

  connection {
    type     = "ssh"
    user     = "${var.user}"
    private_key = tls_private_key.gen_ssh_key.private_key_pem
    host     = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/${var.user}/minio",
      "mkdir /home/${var.user}/docker",
      "mkdir /home/${var.user}/code-server"
    ]
  }

  provisioner "file" {
  source      = "files/code-server.sh"
  destination = "/home/${var.user}/code-server.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo 'IP=${self.ipv4_address}' | sudo tee -a /etc/profile",
      ". /etc/profile",
      "chmod +x /home/${var.user}/code-server.sh",
      "sudo /home/${var.user}/code-server.sh",
      "mkdir /home/${var.user}/certs",
      "sudo curl -fsSL https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 -o /usr/local/bin/mkcert",
      "sudo chmod +x /usr/local/bin/mkcert",
      "mkcert -install",
      "sudo update-ca-certificates",
      "mkcert -cert-file /home/${var.user}/certs/public.crt -key-file /home/${var.user}/certs/private.key ${self.ipv4_address}",
      "openssl verify -verbose -CAfile ~/.local/share/mkcert/rootCA.pem /home/${var.user}/certs/public.crt",
      "mkdir -p /home/${var.user}/.minio/certs",
      "cp /home/${var.user}/certs/* /home/${var.user}/.minio/certs/"
    ]
  }

  provisioner "file" {
  source      = "files/docker-compose.yml"
  destination = "/home/${var.user}/docker/docker-compose.yml"
  }

  provisioner "file" {
  source      = "assets/static/nginx.conf"
  destination = "/home/${var.user}/docker/nginx.conf"
  }
}

