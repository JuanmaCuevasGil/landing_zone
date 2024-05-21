# Creation of the VPC in the specified region with randomly generated suffix
resource "aws_vpc" "this" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "vpc-${var.suffix}"
  }
}

# Creation of the public network in the specified VPC with randomly generated suffix, instances launched here will receive a public IP
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.cidr_map["public"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet-${var.suffix}"
  }
}

# Creation of the private network in the specified VPC with randomly generated suffix, launched after the creation of the public subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.cidr_map["private"]
  tags = {
    "Name" = "private_subnet-${var.suffix}"
  }
  depends_on = [aws_subnet.public]
}

# Creation of the Internet Gateway in the specified VPC with randomly generated suffix
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "igw-${var.suffix}"
  }
}

# Creation of a public route table in a specific VPC. The route table includes a route that sends all traffic through an Internet Gateway (IGW).
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.cidr_map["any"]
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    "Name" = "public_rt-${var.suffix}"
  }
}

# Asociamos la tabla de enrutamiento a la subnet pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Creates a security group for a specific VPC, allowing SSH access from any IP and permitting all outbound traffic. It dynamically sets up inbound rules based on a list of ports, and tags the security group with a name that includes a variable suffix.
resource "aws_security_group" "public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocols["tcp"]
      cidr_blocks = [var.cidr_map["any"]]
    }
  }

  egress {
    from_port        = var.ports["socket"]
    to_port          = var.ports["socket"]
    protocol         = var.protocols["any"]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "public_instance_sg-${var.suffix}"
  }
}
