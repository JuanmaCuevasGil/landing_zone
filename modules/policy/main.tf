resource "aws_iam_policy" "s3_access_policy" {
  name = "s3_access_policy"
  description = "Policy for accessing specific S3 bucket"
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_iam_policy_attachment" "attach_s3_policy" {
  name       = "attach_s3_policy"
  policy_arn = aws_iam_policy.s3_access_policy.arn
  groups     = [var.iam_group_name]
}