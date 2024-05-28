# Creation of a public route table in a specific VPC. The route table includes a route that sends all traffic through an Internet Gateway (IGW).
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_map["any"]
    gateway_id = var.ig_id
  }

  tags = {
    "Name" = "private_rt-${var.suffix}"
  }
}

# Creation of a private route table in a specific VPC. The route table includes a route that sends SSH traffic through an NAT Gateway.
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  
  route {
    cidr_block = var.cidr_map["any"]
    network_interface_id = var.network_interface_id
  }

  tags = {
    "Name" = "public_rt-${var.suffix}"
  }
}

# We associate the routing table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = var.subnet_id["public"]
  route_table_id = aws_route_table.public.id
}

# We associate the routing table with the private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = var.subnet_id["private"]
  route_table_id = aws_route_table.private.id
}