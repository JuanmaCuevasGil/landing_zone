# We indicate the IDs of the instances, for each generated instance (k), we return its ID by accessing it through v.id
output "instance_ids" {
  description = "IDs of the instances"
  value       = { for name, instance in aws_instance.instance : name => instance.id }
}

output "instance_arns" {
  description = "ARNs of the instances"
  value       = { for name, instance in aws_instance.instance : name => instance.arn }
}

output "private_ips" {
  description = "Private ips of the public instances"
  value       = { for name, instance in aws_instance.instance : name => instance.private_ip }
}