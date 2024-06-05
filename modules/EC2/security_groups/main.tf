# Creates a security group for a specific VPC, allowing SSH access from any IP and permitting all outbound traffic. It dynamically sets up inbound rules based on a list of ports, and tags the security group with a name that includes a variable suffix.
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