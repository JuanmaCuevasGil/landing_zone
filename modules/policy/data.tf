# Define an IAM policy document specifying actions and resources for accessing a specific S3 bucket
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*"
    ]
  }
}
