# Create a bucket with a randomly generated name from the locals file in the main branch
resource "aws_s3_bucket" "dc_bucket" {
    bucket = var.bucket_name
}