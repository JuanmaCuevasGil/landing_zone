
# Creation of public instances given the length of the list, of the type of the specified AMI 
# with our own assigned key for SSH access. These belong to the public network and share the same 
# bootstrap script.
resource "aws_instance" "instance" {
  for_each               = local.filtered_ec2_specs
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.type
  subnet_id              = var.subnet_ids[each.value]
  key_name               = var.keys.key_name[each.value]
  vpc_security_group_ids = [var.sg_ids[each.value]]
  user_data              = local.scripts[each.key]
  tags = {
    "Name" = "${each.key}-${var.suffix}"
  }
}
