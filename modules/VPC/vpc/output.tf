output "vpc_ids" {
  value = {
    virginia = aws_vpc.virginia.id
    vpn      = aws_vpc.vpn.id
  }
}

output "subnet_ids" {
  value = { 
    private = aws_subnet.private.id
    public = aws_subnet.public.id
    vpn = aws_subnet.vpn.id
  }
}