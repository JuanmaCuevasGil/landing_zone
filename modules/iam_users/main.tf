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

# Create aleatory password to users
resource "random_password" "user_password" {
  for_each = var.iam_users
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_iam_user_login_profile" "credentials" {
  for_each = var.iam_users
  user = each.key
  password_reset_required = true
}