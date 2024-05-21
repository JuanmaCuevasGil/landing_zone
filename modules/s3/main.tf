# Create a bucket with a randomly generated name from the locals file in the main branch
resource "aws_s3_bucket" "dc_bucket" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket" "vpc_flow_log_bucket" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.vpc_flow_log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.vpc_flow_log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
