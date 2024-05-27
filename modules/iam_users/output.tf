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

output "encrypted_passwords" {
  value = {
    for username, profile in aws_iam_user_login_profile.example :
    username => <<EOF
    ----BEGIN PGP MESSAGE-----
  Version: Keybase OpenPGP v2.1.13
  Comment: https://keybase.io/crypto
 
  ${profile.encrypted_password}
  -----END PGP MESSAGE-----
EOF
  }
}