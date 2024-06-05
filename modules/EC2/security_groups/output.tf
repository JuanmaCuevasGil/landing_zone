output "sg_ids" {
  value       = { for tipo, sg in aws_security_group.sg : tipo => sg.id }
}
