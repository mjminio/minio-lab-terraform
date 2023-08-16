resource "aws_route53_record" "route53_hcloud_dns" {
  count   = var.dns_service == "route53" && var.hcloud_server_count > 0 ? var.hcloud_server_count : 0
  zone_id = var.aws_rt53_zone_id
  name    = element(hcloud_server.minio_lab_server.*.name, count.index)
  type    = "A"
  ttl     = "60"
  records = [element(hcloud_server.minio_lab_server.*.ipv4_address, count.index)]
  depends_on = [hcloud_server.minio_lab_server]
}

resource "aws_route53_record" "route53_code_hcloud_dns" {
  count   = var.dns_service == "route53" && var.hcloud_server_count > 0 ? var.hcloud_server_count : 0
  zone_id = var.aws_rt53_zone_id
  name    = "*.${element(hcloud_server.minio_lab_server.*.name, count.index)}"
  type    = "A"
  ttl     = "60"
  records = [element(hcloud_server.minio_lab_server.*.ipv4_address, count.index)]
  depends_on = [hcloud_server.minio_lab_server]
}