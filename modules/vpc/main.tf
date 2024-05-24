# Creation of the VPC in the specified region with randomly generated suffix
resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "vpc-${var.suffix}"
  }
}

# Creation of the public network in the specified VPC with randomly generated suffix, instances launched here will receive a public IP
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.cidr_map["public"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet-${var.suffix}"
  }
}

# Creation of the private network in the specified VPC with randomly generated suffix, launched after the creation of the public subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.cidr_map["private"]
  tags = {
    "Name" = "private_subnet-${var.suffix}"
  }
  depends_on = [aws_subnet.public]
}

# Creation of the Internet Gateway in the specified VPC with randomly generated suffix
resource "aws_internet_gateway" "ig_virginia" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    "Name" = "igw-${var.suffix}"
  }
}

# Random Elastic IP
resource "aws_eip" "my_eip" {
  vpc      = true
}

# NAT Gateway for private subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public.id
}

# Creation of a public route table in a specific VPC. The route table includes a route that sends all traffic through an Internet Gateway (IGW).
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = var.cidr_map["any"]
    gateway_id = aws_internet_gateway.ig_virginia.id
  }

  tags = {
    "Name" = "private_rt-${var.suffix}"
  }
}

# Creation of a private route table in a specific VPC. The route table includes a route that sends SSH traffic through an NAT Gateway.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_virginia.id
  depends_on = [ aws_nat_gateway.nat_gateway ]
  route {
    cidr_block = var.cidr_map["any"]
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    "Name" = "public_rt-${var.suffix}"
  }
}

# We associate the routing table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# We associate the routing table with the private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Creates a security group for a specific VPC, allowing SSH access from any IP and permitting all outbound traffic. It dynamically sets up inbound rules based on a list of ports, and tags the security group with a name that includes a variable suffix.
resource "aws_security_group" "public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  dynamic "ingress" {
    # Remove cases any and default from our list because they deny or allow all traffic and we need to specify
    for_each = {
      for key, value in var.ports : key => value
      if key != "any" && key != "default"
    }
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
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
    "Name" = "public_instance_sg-${var.suffix}"
  }
}

# Creates a security group for a specific VPC, allowing SSH access from any IP. It dynamically sets up inbound rules based on a list of ports, and tags the security group with a name that includes a variable suffix.
resource "aws_security_group" "private_instance" {
  name        = "Private Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

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
    "Name" = "private_instance_sg-${var.suffix}"
  }
}
