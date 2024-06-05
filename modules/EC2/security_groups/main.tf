# Creates a security group dinamically for a specific VPC, allowing ports access 
# from any specified IP range and permitting all outbound traffic. It depends of 
# the ports variable from terraform.tfvars
resource "aws_security_group" "sg" {
  for_each = var.ports
  name     = each.key
  vpc_id   = each.key == "vpn" ? var.vpc_ids["vpn"] : var.vpc_ids["virginia"]

  dynamic "ingress" {
    # Remove cases any and default from our list because they deny or allow all traffic and we need to specify
    for_each = each.value.ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = [var.cidr_map["any"]]
    }
  }
  egress {
    from_port   = each.value.egress["from_port"]
    to_port     = each.value.egress["to_port"]
    protocol    = each.value.egress["protocol"]
    cidr_blocks = [var.cidr_map["any"]]
  }

  tags = {
    "Name" = "SG-${each.key}"
  }
}