resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "vpc_virginia-${local.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.cidr_map["public"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet_temp-${local.sufix}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.cidr_map["private"]
  tags = {
    "Name" = "private_subnet_temp-${local.sufix}"
  }
  depends_on = [aws_subnet.public_subnet]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = var.cidr_map["any"]
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

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
    protocol         = var.ports["any"]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public Instance SG-${local.sufix}"
  }
}

module "mybucket" {
  source      = "./modulos/s3"
  bucket_name = "nombreunico12345678901"
}