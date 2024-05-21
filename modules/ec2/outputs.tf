# We indicate the IDs of the instances, for each generated instance (k), we return its ID by accessing it through v.id
output "public_instance_ids" {
  description = "IDs of the public instances"
  value       = { for k, v in aws_instance.public_instance : k => v.id }
}

# We indicate the monitoring instance ID and access the first element of the list
output "monitoring_instance_id" {
  description = "ID of the monitoring instance"
  value       = aws_instance.monitoring_instance[0].id
}
