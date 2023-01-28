resource "cloudflare_record" "cloudflare_hcloud_dns" {
  count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
  zone_id = var.cloudflare_zone_id
  name   = "${element(hcloud_server.minio_lab_server.*.name, count.index)}"
  value  = "${element(hcloud_server.minio_lab_server.*.ipv4_address, count.index)}"
  type   = "A"
  ttl = 60
  depends_on = [hcloud_server.minio_lab_server]
}

resource "cloudflare_record" "cloudflare_code_hcloud_dns" {
  count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
  zone_id = var.cloudflare_zone_id
  name   = "code.${element(hcloud_server.minio_lab_server.*.name, count.index)}"
  value  = "${element(hcloud_server.minio_lab_server.*.ipv4_address, count.index)}"
  type   = "A"
  ttl = 60
  depends_on = [hcloud_server.minio_lab_server]
}

# resource "cloudflare_record" "cloudflare_hcloud_code_dns" {
#   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "code-${element(hcloud_server.cape_demo_server.*.name, count.index)}"
#   value  = "${element(hcloud_server.cape_demo_server.*.ipv4_address, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [hcloud_server.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_hcloud_aks_dns" {
#   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "aks-${element(hcloud_server.cape_demo_server.*.name, count.index)}"
#   value  = "${element(hcloud_server.cape_demo_server.*.ipv4_address, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [hcloud_server.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_hcloud_eks_dns" {
#   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "eks-${element(hcloud_server.cape_demo_server.*.name, count.index)}"
#   value  = "${element(hcloud_server.cape_demo_server.*.ipv4_address, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [hcloud_server.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_hcloud_k3s_dns" {
#   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "k3s-${element(hcloud_server.cape_demo_server.*.name, count.index)}"
#   value  = "${element(hcloud_server.cape_demo_server.*.ipv4_address, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [hcloud_server.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_hcloud_smokeamazon_dns" {
#   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "smokeamazon-${element(hcloud_server.cape_demo_server.*.name, count.index)}"
#   value  = "${element(hcloud_server.cape_demo_server.*.ipv4_address, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [hcloud_server.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_hcloud_smokeazure_dns" {
#   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "smokeazure-${element(hcloud_server.cape_demo_server.*.name, count.index)}"
#   value  = "${element(hcloud_server.cape_demo_server.*.ipv4_address, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [hcloud_server.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_demo_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_code_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "code-${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_aks_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "aks-${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_eks_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "eks-${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_k3s_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "k3s-${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_smokeamazon_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "smokeamazon-${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# resource "cloudflare_record" "cloudflare_aws_smokeazure_dns" {
#   count  = "${var.aws_enabled == "true" && var.dns_service == "cloudflare" && var.aws_instance_count > 0 ? var.aws_instance_count:0}"
#   zone_id = var.cloudflare_zone_id
#   name   = "smokeazure-${element(aws_instance.cape_demo_server[*].tags.Name, count.index)}"
#   value  = "${element(aws_instance.cape_demo_server[*].public_ip, count.index)}"
#   type   = "A"
#   ttl = 60
#   depends_on = [aws_instance.cape_demo_server]
# }

# # resource "cloudflare_record" "cloudflare_aks_dns" {
# #   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
# #   zone_id = var.cloudflare_zone_id
# #   name   = "aks-${hcloud_server.cape_demo_server[*].name}"
# #   value  = hcloud_server.cape_demo_server[0].ipv4_address
# #   type   = "A"
# #   ttl = 60
# #   depends_on = [hcloud_server.cape_demo_server]
# # }

# # resource "cloudflare_record" "cloudflare_eks_dns" {
# #   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
# #   zone_id = var.cloudflare_zone_id
# #   name   = "eks-${hcloud_server.cape_demo_server[*].name}"
# #   value  = hcloud_server.cape_demo_server[0].ipv4_address
# #   type   = "A"
# #   ttl = 60
# #   depends_on = [hcloud_server.cape_demo_server]
# # }

# # resource "cloudflare_record" "cloudflare_k3s_dns" {
# #   count  = "${var.dns_service == "cloudflare" && var.hcloud_server_count > 0 ? var.hcloud_server_count:0}"
# #   zone_id = var.cloudflare_zone_id
# #   name   = "k3s-${hcloud_server.cape_demo_server[*].name}"
# #   value  = hcloud_server.cape_demo_server[0].ipv4_address
# #   type   = "A"
# #   ttl = 60
# #   depends_on = [hcloud_server.cape_demo_server]
# # }