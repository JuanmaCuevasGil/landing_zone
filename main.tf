resource "aws_vpc" "default" {
  provider = aws.us-east-2

  tags       = merge(var.tags, {})
  cidr_block = var.vpc_cidr
}

resource "aws_flow_log" "default" {
  provider = aws.us-east-2

  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_instance" "Web Application" {
  provider = aws.eu-north-1

  tags              = merge(var.tags, {})
  subnet_id         = aws_subnet.public_b.id
  availability_zone = "us-east-2b"
}

resource "aws_instance" "BBDD" {
  provider = aws.eu-north-1

  tags              = merge(var.tags, {})
  subnet_id         = aws_subnet.private_b.id
  availability_zone = "us-east-2b"
}

