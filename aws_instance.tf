resource "aws_key_pair" "minio_lab_key" {
  count      = var.aws_enabled ? 1 : 0
  key_name   = "${var.deployment_name}-minio-lab-key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "aws_init" {
  count    = var.aws_enabled ? 1 : 0
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars     = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "aws_security_group" "minio_allow_all" {
  count       = var.aws_enabled ? 1 : 0
  name        = "All_Traffic"
  description = "Allow all inbound traffic (deployed for Minio labs.)"


  ingress {
    description      = "All Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "minio-aws-server-allow_all"
  }
}

resource "aws_instance" "minio_lab_server" {
  count         = var.aws_enabled ? var.aws_instance_count : 0
  ami           = var.aws_instance_image
  instance_type = var.aws_instance_size
  key_name = aws_key_pair.minio_lab_key[0].key_name
  associate_public_ip_address = true
  user_data = "${data.template_file.aws_init[0].rendered}"
  root_block_device {
    volume_size = "100"
  }

  vpc_security_group_ids = ["${aws_security_group.minio_allow_all[0].id}"]

  tags = {
    Name = "${var.deployment_name}-aws-${count.index}"
  }

}