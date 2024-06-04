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
    actions = [
      "iam:*",
      "cloudtrail:*",
      "config:*",
      "guardduty:*",
      "inspector:*",
      "waf:*",
      "shield:*",
      "macie:*",
      "s3:ListAllMyBuckets",
      "s3:GetObject", 
      "s3:PutObject", 
      "s3:ListBucket",
      "ec2:DescribeInstances",
      "ec2:DescribeImages",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeRegions",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeAddresses",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "compute-optimizer:GetEnrollmentStatus"
    ]
    resources = [
      "*",
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2-instance-connect:SendSSHPublicKey"
    ]
    resources = [
      "${var.jumpserver_arn}"]
  }

  statement {
    effect = "Deny"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:TerminateInstances"
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
      "elasticloadbalancing:*",
      "ec2-instance-connect:*",
      "compute-optimizer:GetEnrollmentStatus"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Deny"
    actions = [
      "ec2-instance-connect:SendSSHPublicKey"
    ]
    resources = [
      "${var.jumpserver_arn}"]
  }

  statement {
    effect = "Deny"
    actions   = [
      "s3:GetObject", 
      "s3:PutObject", 
      "s3:ListBucket"]
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*"
    ]
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
