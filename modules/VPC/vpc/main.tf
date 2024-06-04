# Creation of the VPC in the specified region with randomly generated suffix
resource "aws_vpc" "virginia" {
  cidr_block = var.cidr_map["virginia"]
  tags = {
    "Name" = "VPC-Virginia"
  }
}

# Creation of the VPC in the specified region with randomly generated suffix for the VPN
resource "aws_vpc" "vpn" {
  cidr_block = var.cidr_map["vpn"]
}

# Creation of the public network in the specified VPC with randomly generated suffix, instances launched here will receive a public IP
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.virginia.id
  cidr_block              = var.cidr_map["public"]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "PubSub-Virginia"
  }
}

# Creation of the private network in the specified VPC with randomly generated suffix, launched after the creation of the public subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.virginia.id
  cidr_block = var.cidr_map["private"]
  tags = {
    "Name" = "PrivSub-Virginia"
  }
}

# Creation of a public network in the specified VPC with randomly generated suffix
resource "aws_subnet" "vpn" {
  vpc_id                  = aws_vpc.vpn.id
  map_public_ip_on_launch = true
  cidr_block              = var.cidr_map["vpn_subnet"]
  tags = {
    "Name" = "VPNSub-Virginia"
  }
}

# Creation of the Internet Gateway in the specified VPC with randomly generated suffix
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
  subnet_id     = aws_subnet.public.id
}

# Creation of a public route table in a specific VPC. The route table includes a route that sends all traffic through an Internet Gateway (IGW).
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

# Creation of a private route table in a specific VPC. The route table includes a route that sends SSH traffic through an NAT Gateway.
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

resource "aws_route_table_association" "routes_assoc" {
  for_each = {
    public  = aws_route_table.public
    private = aws_route_table.private
    vpn     = aws_route_table.vpn
  }
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# We associate the routing table with the private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "vpn" {
  subnet_id      = aws_subnet.vpn.id
  route_table_id = aws_route_table.vpn.id
}

# resource "aws_customer_gateway" "vpn" {
#   bgp_asn    = 65000
#   ip_address = aws_instance.vpn.public_ip
#   type       = "ipsec.1"
# }

# resource "aws_vpn_gateway" "vpn" {
#   vpc_id = aws_vpc.vpc_virginia.id
# }

# resource "aws_vpn_connection" "vpn" {
#   customer_gateway_id = aws_customer_gateway.vpn.id
#   vpn_gateway_id      = aws_vpn_gateway.vpn.id
#   type                = "ipsec.1"

#   static_routes_only = true
# }

# resource "aws_vpn_connection_route" "vpn" {
#   vpn_connection_id      = aws_vpn_connection.vpn.id
#   destination_cidr_block = "10.10.0.0/24"
# }

# resource "aws_route" "vpn_route" {
#   route_table_id         = aws_route_table.public_vpn.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.ig_virginia_2.id
#   depends_on             = [aws_vpc.virginia_vpn]
# }

# resource "aws_vpn_gateway_route_propagation" "main" {
#   vpn_gateway_id = aws_vpn_gateway.vpn.id
#   route_table_id = aws_route_table.public.id
# }
