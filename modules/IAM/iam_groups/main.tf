# Creates IAM groups in AWS. 
resource "aws_iam_group" "groups" {
  for_each = toset(var.iam_groups)
  name = each.key
}

