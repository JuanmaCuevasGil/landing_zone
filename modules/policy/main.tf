# Define an IAM policy for accessing a specific S3 bucket
resource "aws_iam_policy" "policy" {
  for_each = toset(var.iam_group)
  name        = each.key
  description = "Policy for accessing specific S3 bucket"
  policy      = local.policy_documents[each.key]
}

# Attach the IAM policy to a specified IAM group
resource "aws_iam_policy_attachment" "attach_policy" {
  for_each = toset(var.iam_group)
  name       = each.key
  policy_arn = aws_iam_policy.policy[each.key].arn
  groups     = [each.key]
}