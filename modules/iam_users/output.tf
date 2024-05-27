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

# Output the generated passwords
output "user_passwords" {
  value = {
    for user_key, _ in aws_iam_user_login_profile.credentials : user_key => aws_iam_user_login_profile.credentials[user_key].password
  }
}