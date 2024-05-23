# Creation of public instances given the length of the list, of the type of the specified AMI 
# with our own assigned key for SSH access. These belong to the public network and share the same 
# bootstrap script.
resource "aws_instance" "public_instance" {
  for_each               = var.instance_name
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.public_sg_id]
  user_data              = each.value != "jumpserver" ? file("${path.module}/scripts/${each.value}.sh") : <<-EOF
  #!/bin/bash
  sudo mkdir .ssh
  sudo echo "${var.key_pair_pem}" > /.ssh/${var.key_private_name}.pem
  sudo chmod 400 .ssh/${var.key_private_name}.pem
  EOF
  tags = {
    "Name" = "${each.value}-${var.suffix}"
  }
}

# Creation of a monitoring instance in a private network based on whether true or false is indicated
resource "aws_instance" "monitoring_instance" {
  count                  = var.enable_monitoring ? 1 : 0
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = var.key_private_name
  vpc_security_group_ids = [var.private_sg_id]
  tags = {
    "Name" = "Monitoring-${var.suffix}"
  }
}
