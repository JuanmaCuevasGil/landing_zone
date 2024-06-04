output "iam_groups_name" {
  description = "IDs of the public instances"
  value       = { for k, v in aws_iam_group.groups : k => v.name }
}