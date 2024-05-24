# Create a bucket with a randomly generated name from the locals file in the main branch
resource "aws_s3_bucket" "dc_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Configurating a resource to stablish the versioning in our logs bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.dc_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.dc_bucket.id

  rule {
    id = "log"

    expiration {
      days = var.config_time["expiration"]
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = var.config_time["standard_ia"]
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.config_time["glacier"]
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      date = "2023-01-13T00:00:00Z"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "versioning-${var.bucket_name}"
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.versioning_bucket.id

  rule {
    id = "config"

    filter {
      prefix = "config/"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.config_time["expiration"]
    }

    noncurrent_version_transition {
      noncurrent_days = var.config_time["standard_ia"]
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.config_time["glacier"]
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}
