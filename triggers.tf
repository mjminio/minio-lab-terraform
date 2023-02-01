# Cleans up folders on destroy

resource "null_resource" "deployment_folder" {
  triggers = {
    deployment_folder = var.deployment_name
  }

  provisioner "local-exec" {
    command = "rm -rf ansible/files/${self.triggers.deployment_folder}"
    when = destroy
  }

  provisioner "local-exec" {
    command = "rm -rf ansible/inventory/${self.triggers.deployment_folder}"
    when = destroy
  }
}