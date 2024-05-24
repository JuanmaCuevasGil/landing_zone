# Outputs IAM user access keys.
output "user_access_key" {
  value = {
    for user, key in aws_iam_access_key.access_key :
    user => {
      access_key_id     = key.id
      secret_access_key = key.secret
    }
  }
  sensitive = true
}
