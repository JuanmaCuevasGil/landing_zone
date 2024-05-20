resource "aws_internet_gateway" "default" {
  provider = aws.us-east-2

  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_subnet" "public_b" {
  provider = aws.us-east-2

  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.b
  availability_zone = "us-east-2b"
}

resource "aws_eip" "eip_b" {
  provider = aws.us-east-2

  tags = merge(var.tags, {})
}

resource "aws_nat_gateway" "nat-gw-2b-public" {
  provider = aws.us-east-2

  tags      = merge(var.tags, {})
  subnet_id = aws_subnet.public_b.id
}

resource "aws_route_table" "rt_public_b" {
  provider = aws.us-east-2

  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

