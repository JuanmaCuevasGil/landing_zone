output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}

output "acces_key_iam_users" {
  value     = module.iam_users.user_access_key
  sensitive = true
}

output "password" {
  value     = module.iam_users.user_passwords
  sensitive = true
}

output "key_pair_public" {
  value     = replace(module.key_pair.key_pair_pem_public, "\\n", "\n")
  sensitive = true
}

output "key_pair_private" {
  value     = module.key_pair.key_pair_pem_private
  sensitive = true
}

output "name" {
  value = module.myinstances.public_instance_arn
}