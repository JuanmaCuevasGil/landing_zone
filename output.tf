output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}

output "acces_key_iam_users" {
  value = module.iam_users.user_access_key
  sensitive = true
}

output "password" {
  value = module.iam_users.encrypted_passwords
}