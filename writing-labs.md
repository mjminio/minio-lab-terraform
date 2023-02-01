## How To Use Labs
Using the {{ open }} command allows you to open a file

Using the {{ execute }} command allows you to execute a command in the terminal

Using the {{ execute interrupt }} kills a command

Using the {{ execute T2 }} runs in second command window

Using the {{ copy }} copies the text

## Example Labs

1. Run `docker ps` to list containers
`docker ps` {{ execute }}
<br>
2. Run `docker ps -a` to list all containers including stopped containers
`docker ps -a` {{ execute }}
<br>
3. Run a docker container
`docker run nginx` {{ execute }}
<br>
4. Stop the container as it is running in the forground.
`Ctrl+C`{{ execute interrupt}}
<br>
5. Open a local file
`./example.json` {{ open }}
<br>
6. Follow this link for more information
https://min.io

## Example code block

```
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
```