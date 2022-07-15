resource "local_file" "minio_docker" {
  content  = templatefile("./assets/templates/docker-compose.yml.tmpl", {
      minio_password = var.minio_password,
      user = var.user
      }
    )
  filename = "./files/docker-compose.yml"
}

resource "local_file" "install_code_server" {
  content  = templatefile("./assets/templates/code-server.sh.tmpl", {
      user = var.user,
      code_server_password = var.code_server_password,
      code_server_version = var.code_server_version,
      lab_repo_url = var.lab_repo_url
      }
    )
  filename = "./files/code-server.sh"
}

resource "local_file" "start_minio_docker" {
  content  = templatefile("./assets/templates/start-minio-docker.sh.tmpl", {
      user = var.user,
      hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address
      do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address
      }
    )
  filename = "./files/start-minio-docker.sh"
  depends_on = [hcloud_server.minio_lab_server]
}

resource "local_file" "start_minio_native" {
  content  = templatefile("./assets/templates/start-minio-native.sh.tmpl", {
      user = var.user,
      minio_password = var.minio_password
      hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
      do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address
      }
    )
  filename = "./files/start-minio-native.sh"
  depends_on = [hcloud_server.minio_lab_server]
}

resource "local_file" "minio_ui" {
  content  = templatefile("./assets/templates/minio-ui-links.txt.tmpl", {
      do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address,
      hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
      user = var.user,
      minio_password = var.minio_password,
      code_server_password = var.code_server_password,
      }
    )
  filename = "./files/minio-ui-links.txt"
}

resource "local_file" "mc_setup" {
  content  = templatefile("./assets/templates/minio-client-setup.sh.tmpl", {
      minio_password = var.minio_password,
      minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
      name = hcloud_server.minio_lab_server[*].name
      user = var.user,
      }
    )
  filename = "./files/minio-client-setup.sh"
  depends_on = [hcloud_server.minio_lab_server]
}

# General Outputs
output "ssh-key" {
  value = local_file.ssh_key.filename
}

## HCloud output
output "hcloud_minio_servers_status" {
  value = {
    for server in hcloud_server.minio_lab_server :
    server.name => server.status
  }
}

output "hcloud_minio_servers_ips" {
  value = {
    for server in hcloud_server.minio_lab_server :
    server.name => server.ipv4_address
  }
}

## DO output
output "do_minio_servers_status" {
  value = {
    for server in digitalocean_droplet.minio_lab_server :
    server.name => server.status
  }
}

output "do_minio_servers_ips" {
  value = {
    for server in digitalocean_droplet.minio_lab_server :
    server.name => server.ipv4_address
  }
}