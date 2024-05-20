output "public_instance_ids" {
  description = "IDs of the public instances"
  value       = { for k, v in aws_instance.public_instance : k => v.id }
}

output "monitoring_instance_id" {
  description = "ID of the monitoring instance"
  value       = aws_instance.monitoring_instance[0].id
}
