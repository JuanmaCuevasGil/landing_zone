resource "aws_vpc" "this" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "vpc-${var.suffix}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.cidr_map["public"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet-${var.suffix}"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.cidr_map["private"]
  tags = {
    "Name" = "private_subnet-${var.suffix}"
  }
  depends_on = [aws_subnet.public]
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "igw-${var.suffix}"
  }
}

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

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

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
