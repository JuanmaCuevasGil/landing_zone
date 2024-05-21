output "s3_bucket_arn" {
  value = aws_s3_bucket.dc_bucket.arn
}

output "s3_bucket_arn_vpc" {
  value = aws_s3_bucket.vpc_flow_log_bucket.arn
}