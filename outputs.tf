resource "local_file" "ansible_inventory" {
  content  = templatefile("./assets/templates/ansible-inventory.tmpl", {
      hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
      hcloud_name = hcloud_server.minio_lab_server[*].name,
      do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address,
      do_name = digitalocean_droplet.minio_lab_server[*].name,
      aws_minio_ips = aws_instance.minio_lab_server[*].public_ip,
      aws_name = aws_instance.minio_lab_server[*].tags.Name,
      private_key = "./files/${var.deployment_name}/${var.deployment_name}-private-key.pem",
      user = var.user,
      deployment_name = var.deployment_name,
      }
    )
  filename = "./ansible/inventory/${var.deployment_name}/${var.deployment_name}-inventory"
  depends_on = [hcloud_server.minio_lab_server]
}

resource "local_file" "ansible_config" {
  content  = templatefile("./assets/templates/ansible.cfg.tmpl", {
      deployment_name = var.deployment_name
      }
    )
  filename = "./ansible/ansible.cfg"
}

resource "local_file" "ansible_all" {
  content  = templatefile("./assets/templates/all.tmpl", {
      deployment_name = var.deployment_name,
      user = var.user,
      ansible_user = var.user,
      environment_systemd_directory = var.environment_systemd_directory,
      docker_compose_version = var.docker_compose_version,
      lab_repo_url = var.lab_repo_url,
      code_server_version = var.code_server_version,
      code_server_password = var.code_server_password
      shutdown_after_time = var.shutdown_after_time
      minio_password = var.minio_password
      }
    )
  filename = "./ansible/inventory/${var.deployment_name}/group_vars/all.yml"
}

resource "local_file" "mc_setup" {
  content  = templatefile("./assets/templates/tools/mc/minio-client-setup.sh.tmpl", {
      minio_password = var.minio_password,
      hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
      hcloud_name = hcloud_server.minio_lab_server[*].name,
      do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address,
      do_name = digitalocean_droplet.minio_lab_server[*].name,
      aws_minio_ips = aws_instance.minio_lab_server[*].public_ip,
      aws_name = aws_instance.minio_lab_server[*].tags.Name,
      user = var.user
      }
    )
  filename = "ansible/files/${var.deployment_name}/minio-client-setup.sh"
  depends_on = [hcloud_server.minio_lab_server]
}

locals {
  names = concat(hcloud_server.minio_lab_server[*].name, digitalocean_droplet.minio_lab_server[*].name, aws_instance.minio_lab_server[*].tags.Name)
  ips = concat(hcloud_server.minio_lab_server[*].ipv4_address, digitalocean_droplet.minio_lab_server[*].ipv4_address, aws_instance.minio_lab_server[*].public_ip)
}

resource "local_file" "mc_repl_setup" {
  content  = templatefile("./assets/templates/tools/mc/minio-site-repl-setup.sh.tmpl", {
      server_names = local.names 
      }
    )
  filename = "ansible/files/${var.deployment_name}/minio-site-repl-setup.sh"
  depends_on = [hcloud_server.minio_lab_server]
}

resource "local_file" "minio_native_start_all" {
  content  = templatefile("./assets/templates/tools/native/minio-native-start-all.sh.tmpl", {
      server_ips = local.ips
      user = var.user
      }
    )
  filename = "ansible/files/${var.deployment_name}/minio-native-start-all.sh"
  depends_on = [hcloud_server.minio_lab_server]
}

# ## Server Setup Scripts
# resource "local_file" "install_code_server" {
#   content  = templatefile("./assets/templates/code-server.sh.tmpl", {
#       user = var.user,
#       code_server_password = var.code_server_password,
#       code_server_version = var.code_server_version,
#       lab_repo_url = var.lab_repo_url
#       }
#     )
#   filename = "./files/code-server.sh"
# }

# ## Minio Deployment Scripts 

# ### Minio Docker Compose Scripts
# resource "local_file" "minio_docker" {
#   content  = templatefile("./assets/templates/tools/docker/compose/docker-compose.yml.tmpl", {
#       minio_password = var.minio_password,
#       user = var.user
#       }
#     )
#   filename = "./files/tools/docker/compose/docker-compose.yml"
# }

# resource "local_file" "start_minio_docker-compose" {
#   content  = templatefile("./assets/templates/tools/docker/compose/minio-docker-compose-start.sh.tmpl", {
#       user = var.user,
#       hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address
#       do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address
#       }
#     )
#   filename = "./files/tools/docker/compose/minio-docker-compose-start.sh"
#   depends_on = [
#     hcloud_server.minio_lab_server
#     ]
# }

# resource "local_file" "stop_minio_docker-compose" {
#   content  = templatefile("./assets/templates/tools/docker/compose/minio-docker-compose-stop.sh.tmpl", {
#       user = var.user,
#       hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address
#       do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address
#       }
#     )
#   filename = "./files/tools/docker/compose/minio-docker-compose-stop.sh"
#   depends_on = [hcloud_server.minio_lab_server]
# }

# ### Minio Native Server Scripts
# resource "local_file" "start_minio_native" {
#   content  = templatefile("./assets/templates/tools/native/minio-native-start.sh.tmpl", {
#       user = var.user,
#       minio_password = var.minio_password
#       hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
#       do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address
#       }
#     )
#   filename = "./files/tools/native/start-minio-native.sh"
#   depends_on = [hcloud_server.minio_lab_server]
# }

# resource "local_file" "minio_ui" {
#   content  = templatefile("./assets/templates/minio-ui-links.txt.tmpl", {
#       do_minio_ips = digitalocean_droplet.minio_lab_server[*].ipv4_address,
#       hcloud_minio_ips = hcloud_server.minio_lab_server[*].ipv4_address,
#       user = var.user,
#       minio_password = var.minio_password,
#       code_server_password = var.code_server_password,
#       G = "\\e[32m"
#       E = "\\e[0m"
#       }
#     )
#   filename = "./files/minio-ui-links.sh"
# }

# # General Outputs
# output "ssh-key" {
#   value = local_file.ssh_key.filename
# }

# ## HCloud output
# output "hcloud_minio_servers_status" {
#   value = {
#     for server in hcloud_server.minio_lab_server :
#     server.name => server.status
#   }
# }

# output "hcloud_minio_servers_ips" {
#   value = {
#     for server in hcloud_server.minio_lab_server :
#     server.name => join("", ["${server.ipv4_address}", ":8080"])
#   }
# }

# ## DO output
# output "do_minio_servers_status" {
#   value = {
#     for server in digitalocean_droplet.minio_lab_server :
#     server.name => server.status
#   }
# }

# output "do_minio_servers_ips" {
#   value = {
#     for server in digitalocean_droplet.minio_lab_server :
#     server.name => server.ipv4_address
#   }
# }