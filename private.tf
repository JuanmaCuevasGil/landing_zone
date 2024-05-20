resource "aws_route_table" "rt_private_b" {
  provider = aws.us-east-2

  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_subnet" "private_b" {
  provider = aws.us-east-2

  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.b
  availability_zone       = "us-east-2b"
}

