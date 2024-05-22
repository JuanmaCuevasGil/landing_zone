output "s3_bucket_arn" {
  value = aws_s3_bucket.dc_bucket.arn
}

output "s3_bucket_object" {
  value = aws_s3_bucket.dc_bucket
}