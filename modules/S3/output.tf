output "s3_bucket_arn" {
  description = "Arn of the s3 bucket"
  value = aws_s3_bucket.dc_bucket.arn
}
