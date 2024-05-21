# Creation of public instances given the length of the list, of the type of the specified AMI 
# with our own assigned key for SSH access. These belong to the public network and share the same 
# bootstrap script.
resource "aws_instance" "public_instance" {
  for_each               = var.instance_name
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  user_data              = file("${path.module}/scripts/userdata.sh")
  tags = {
    "Name" = "${each.value}-${var.suffix}"
  }
}

# Creation of a monitoring instance in a private network based on whether true or false is indicated
resource "aws_instance" "monitoring_instance" {
  count                  = var.enable_monitoring ? 1 : 0
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  user_data              = file("${path.module}/scripts/userdata.sh")
  tags = {
    "Name" = "Monitoreo-${var.suffix}"
  }
}
