output "vpc_ids" {
  description = "Map of subnet ids with names"
  value = {for key, value in aws_vpc.vpcs : key => value.id}
}

output "subnet_ids" {
  description = "Map of subnet ids with names"
  value = {for key, value in aws_subnet.subnets : key => value.id}
}