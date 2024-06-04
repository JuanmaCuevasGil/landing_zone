# Creates a security group for a specific VPC, allowing SSH access from any IP and permitting all outbound traffic. It dynamically sets up inbound rules based on a list of ports, and tags the security group with a name that includes a variable suffix.
resource "aws_security_group" "public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH, IMCP, HTTP, HTTPS inbound traffic and ALL egress traffic"
  vpc_id      = var.vpc_virginia_id

  dynamic "ingress" {
    # Remove cases any and default from our list because they deny or allow all traffic and we need to specify
    for_each = {
      for key, value in var.ports : key => value
      if key != "any" && key != "default"
    }
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.cidr_map["any"]]
    }
  }
  egress {
    from_port   = var.ports["default"].port
    to_port     = var.ports["default"].port
    protocol    = var.ports["default"].protocol
    cidr_blocks = [var.cidr_map["any"]]
  }

  tags = {
    "Name" = "SG-PubSub-Virginia"
  }
}

# Creates a security group for a specific VPC, allowing SSH access from any IP. It dynamically sets up inbound rules based on a list of ports, and tags the security group with a name that includes a variable suffix.
resource "aws_security_group" "private_instance" {
  name        = "Private Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = var.vpc_virginia_id

  ingress {
    from_port   = var.ports["ssh"].port
    to_port     = var.ports["ssh"].port
    protocol    = var.ports["ssh"].protocol
    cidr_blocks = [var.private_ip]
    # security_groups = [ aws_security_group.public_instance.id ]
  }
  egress {
    from_port   = var.ports["default"].port
    to_port     = var.ports["default"].port
    protocol    = var.ports["default"].protocol
    cidr_blocks = [var.cidr_map["any"]]
  }
  tags = {
    "Name" = "SG-PrivSub-Virginia"
  }
}

resource "aws_security_group" "virginia_vpn" {
  name = "allow-all"
  vpc_id = var.vpn_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG-VPN"
  }
}