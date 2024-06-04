# Creation of the VPC in the specified region with randomly generated suffix
resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "VPC-Virginia"
  }
}

# Creation of the public network in the specified VPC with randomly generated suffix, instances launched here will receive a public IP
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.cidr_map["public"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "PubSub-Virginia"
  }
}

# Creation of the private network in the specified VPC with randomly generated suffix, launched after the creation of the public subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.cidr_map["private"]
  tags = {
    "Name" = "PrivSub-Virginia"
  }
  depends_on = [aws_subnet.public]
}

# Creation of the Internet Gateway in the specified VPC with randomly generated suffix
resource "aws_internet_gateway" "ig_virginia" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    "Name" = "IG-Virginia"
  }
}

# Random Elastic IP
resource "aws_eip" "my_eip" {

}

# NAT Gateway for private subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public.id
}

# Creation of a public route table in a specific VPC. The route table includes a route that sends all traffic through an Internet Gateway (IGW).
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    "Name" = "Priv-RT-Virginia"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig_virginia.id
  depends_on             = [aws_vpc.virginia_vpn]
}

# Creation of a private route table in a specific VPC. The route table includes a route that sends SSH traffic through an NAT Gateway.
resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.vpc_virginia.id
  depends_on = [aws_nat_gateway.nat_gateway]
  route {
    cidr_block     = var.cidr_map["any"]
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    "Name" = "Pub-RT-Virginia"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# We associate the routing table with the private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_customer_gateway" "vpn" {
  bgp_asn    = 65000
  ip_address = aws_instance.vpn.public_ip
  type       = "ipsec.1"
}

resource "aws_vpn_gateway" "vpn" {
  vpc_id = aws_vpc.vpc_virginia.id
}

resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = aws_customer_gateway.vpn.id
  vpn_gateway_id      = aws_vpn_gateway.vpn.id
  type                = "ipsec.1"

  static_routes_only = true
}

resource "aws_vpn_connection_route" "vpn" {
  vpn_connection_id      = aws_vpn_connection.vpn.id
  destination_cidr_block = "10.10.0.0/24"
}

resource "aws_instance" "vpn" {
  ami                         = "ami-0e001c9271cf7f3b9"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_vpn.id
  key_name                    = "SSH-Virginia-Public"
  vpc_security_group_ids      = [var.sg_vpn_id]
  associate_public_ip_address = true
}

resource "aws_vpc" "virginia_vpn" {
  cidr_block = "10.20.0.0/16"
}

resource "aws_subnet" "public_vpn" {
  vpc_id                  = aws_vpc.virginia_vpn.id
  map_public_ip_on_launch = true
  cidr_block              = "10.20.0.0/24"
}

resource "aws_internet_gateway" "ig_virginia_2" {
  vpc_id = aws_vpc.virginia_vpn.id
  tags = {
    "Name" = "IG-VPN"
  }
}
resource "aws_route_table" "public_vpn" {
  vpc_id = aws_vpc.virginia_vpn.id

  tags = {
    "Name" = "Priv-RT-VPN"
  }
}
resource "aws_route" "vpn_route" {
  route_table_id         = aws_route_table.public_vpn.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig_virginia_2.id
  depends_on             = [aws_vpc.virginia_vpn]
}

resource "aws_vpn_gateway_route_propagation" "main" {
  vpn_gateway_id = aws_vpn_gateway.vpn.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "vpn_association" {
  subnet_id = aws_subnet.public_vpn.id
  route_table_id = aws_route_table.public_vpn.id
}