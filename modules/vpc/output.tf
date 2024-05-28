output "vpc_id" {
  value = aws_vpc.vpc_virginia.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_security_group_id" {
  value = aws_security_group.public_instance.id
}

output "private_security_group_id" {
  value = aws_security_group.private_instance.id
}

output "ig_id" {
  value = aws_internet_gateway.ig_virginia.id
}