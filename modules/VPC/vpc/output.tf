output "vpc_ids" {
  description = "Map of subnet ids with names"
  value = {
    virginia = aws_vpc.virginia.id
    vpn      = aws_vpc.vpn.id
  }
}

output "subnet_ids" {
  description = "Map of subnet ids with names"
  value = { 
    private = aws_subnet.subnets["private"].id
    public = aws_subnet.subnets["public"].id
    vpn = aws_subnet.subnets["vpn"].id
  }
}