data "aws_iam_policy_document" "aws_admin" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "aws_security" {
  statement {
    effect = "Allow"
    actions   = [
      "s3:GetObject", 
      "s3:PutObject", 
      "s3:ListBucket"]
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:*",
      "cloudtrail:*",
      "config:*",
      "guardduty:*",
      "inspector:*",
      "waf:*",
      "shield:*",
      "macie:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "aws_operations" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "s3:*",
      "rds:*",
      "cloudwatch:*",
      "autoscaling:*",
      "elasticloadbalancing:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "aws_billing" {
  statement {
    effect = "Allow"
    actions = [
      "aws-portal:ViewBilling",
      "aws-portal:ViewAccount",
      "aws-portal:ViewUsage",
      "aws-portal:ViewPaymentMethods",
      "budgets:*",
      "ce:*"
    ]
    resources = ["*"]
  }
}
