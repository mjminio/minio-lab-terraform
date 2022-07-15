resource "aws_key_pair" "minio_lab_key" {
  count      = "${var.aws_enabled ? 1 : 0}"
  key_name   = "minio-lab-key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

data "template_file" "aws_init" {
  template = "${file("./assets/templates/user_data.tmpl")}"
  vars = {
      user = var.user
      ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  }
}

resource "aws_security_group" "minio_allow_all" {
  count      = "${var.aws_enabled ? 1 : 0}"
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
  count         = var.aws_instance_count
  ami           = var.aws_instance_image
  instance_type = var.aws_instance_size
  key_name = aws_key_pair.minio_lab_key[0].key_name
  associate_public_ip_address = true
  user_data = "${data.template_file.aws_init.rendered}"
  root_block_device {
    volume_size = "100"
  }

  vpc_security_group_ids = ["${aws_security_group.minio_allow_all[0].id}"]

  tags = {
    Name = "minio-aws-server-${count.index}"
  }

  connection {
    type     = "ssh"
    user     = "${var.user}"
    private_key = tls_private_key.gen_ssh_key.private_key_pem
    host     = self.public_ip
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