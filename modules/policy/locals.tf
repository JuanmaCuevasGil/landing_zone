locals {
  policy_documents = {
    aws_admin      = data.aws_iam_policy_document.aws_admin.json
    aws_security   = data.aws_iam_policy_document.aws_security.json
    aws_operations = data.aws_iam_policy_document.aws_operations.json
    aws_billing    = data.aws_iam_policy_document.aws_billing.json
  }
}