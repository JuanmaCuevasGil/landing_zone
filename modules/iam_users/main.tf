# Creates IAM users in AWS.
resource "aws_iam_user" "users" {
  for_each = var.iam_users
  name = each.key
}

# Manages user group memberships for IAM users.
resource "aws_iam_user_group_membership" "user_group_memberships" {
  for_each = var.iam_users
  user = aws_iam_user.users[each.key].name
  groups = each.value
}

# Creates access keys for IAM users.
resource "aws_iam_access_key" "access_key" {
  for_each = var.iam_users
  user = aws_iam_user.users[each.key].name
}

resource "aws_iam_account_password_policy" "account_password_policy" {
  minimum_password_length       = 12
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers              = true
  require_symbols              = true
}

resource "random_password" "user_passwords" {
  for_each = var.iam_users
  length   = 16
  special  = true
  override_special = "_%@"
}

resource "aws_iam_user_login_profile" "user_login_profile" {
  for_each                = aws_iam_user.users
  user                    = each.value.name
  password_reset_required = true
}
