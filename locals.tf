# Create an 8-character variable suffix to assign the name to our bucket 
# (No two buckets can exist with the same name)
resource "random_string" "sufijo-s3" {
  length  = 8
  special = false
  upper   = false
}

locals {
  s3-sufix = "vpc-flow-logs-${random_string.sufijo-s3.id}"
}
