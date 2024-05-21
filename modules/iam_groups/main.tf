# Creates IAM groups in AWS. 
resource "aws_iam_group" "groups" {
  for_each = var.iam_groups
  name = each.key
}

# Attaches IAM policies to the IAM groups created above.
resource "aws_iam_group_policy_attachment" "group_policy_attachments" {
  for_each = var.iam_groups
  group = aws_iam_group.groups[each.key].name
  policy_arn = each.value
}

