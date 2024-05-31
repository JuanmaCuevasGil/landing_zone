# We indicate the IDs of the instances, for each generated instance (k), we return its ID by accessing it through v.id
output "public_instance_ids" {
  description = "IDs of the public instances"
  value       = { for name, instance in aws_instance.public_instance : name => instance.id }
}

output "public_instance_arns" {
  description = "ARNs of the public instances"
  value       = { for name, instance in aws_instance.public_instance : name => instance.arn }
}

# We indicate the monitoring instance ID and access the first element of the list
output "monitoring_instance_id" {
  description = "ID of the monitoring instance"
  value       = aws_instance.monitoring_instance[0].id
}

output "private_ip" {
  description = "IDs of the public instances"
  value       = { for name, instance in aws_instance.public_instance : name => instance.private_ip }
}

output "monitoring_instance_arn" {
  description = "ARN of the monitoring instance"
  value = length(aws_instance.monitoring_instance) > 0 ? aws_instance.monitoring_instance[0].arn : null
}