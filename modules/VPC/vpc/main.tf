# Creation of the VPC in the specified region.
resource "aws_vpc" "virginia" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "VPC-Virginia"
  }
}

# Creation of the VPC in the specified region.
resource "aws_vpc" "vpn" {
  cidr_block = var.cidr_map["vpn"]
    tags = {
    "Name" = "VPC-VPN"
  }
}

# Creating subnets dynamically based on cidr and assigning names 
resource "aws_subnet" "subnets" {
  for_each = {
    public  = var.cidr_map["public"]
    private = var.cidr_map["private"]
    vpn     = var.cidr_map["vpn_subnet"]
  }
  vpc_id                  = each.key == "vpn" ? aws_vpc.vpn.id : aws_vpc.virginia.id
  cidr_block              = each.value
  map_public_ip_on_launch = each.key != "private" ? true : false
  tags = {
    "Name" = "${each.key}Sub-Virginia"
  }
}

# Dynamic creation of an internet gateway assigned to a vpc
resource "aws_internet_gateway" "ig" {
  for_each = {
    virginia = aws_vpc.virginia
    vpn      = aws_vpc.vpn
  }
  vpc_id = each.value.id
  tags = {
    "Name" = "IG-${each.key}"
  }
}

# Random Elastic IP
resource "aws_eip" "my_eip" {

}

# NAT Gateway for private subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.subnets["public"].id
}

# Creation of a public route table in a specific VPC. The route table includes a
# route that sends all traffic through an Internet Gateway (IGW).
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.virginia.id

  route {
    cidr_block = var.cidr_map["any"]
    gateway_id = aws_internet_gateway.ig["virginia"].id
  }

  tags = {
    "Name" = "Pub-RT-Virginia"
  }
}

# Creation of a private route table in a specific VPC. The route table includes a 
# route that sends traffic through an NAT Gateway.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.virginia.id

  route {
    cidr_block     = var.cidr_map["any"]
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    "Name" = "Pri-RT-Virginia"
  }
}

# Creation of a route table for the VPC that contains the VPN. The route
# table includes a route that sends traffic through its internet Gateway
resource "aws_route_table" "vpn" {
  vpc_id = aws_vpc.vpn.id

  route {
    cidr_block = var.cidr_map["any"]
    gateway_id = aws_internet_gateway.ig["vpn"].id
  }

  tags = {
    "Name" = "Priv-RT-VPN"
  }
}

# Associate the route tables to each subnet
resource "aws_route_table_association" "routes_assoc" {
  for_each = {
    public  = aws_route_table.public
    private = aws_route_table.private
    vpn     = aws_route_table.vpn
  }
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = each.value.id
}