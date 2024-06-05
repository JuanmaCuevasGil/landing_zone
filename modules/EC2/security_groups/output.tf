output "sg_ids" {
  description = "Map created with type of subnet and passing their security group ids"
  value       = { for type, sg in aws_security_group.sg : type => sg.id }
}
