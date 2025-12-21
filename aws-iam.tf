resource "aws_iam_user" "admin" {
  for_each      = local.admin_users
  name          = each.value
  force_destroy = false
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_user_policy_attachment" "admin_attach" {
  for_each   = local.admin_users
  user       = aws_iam_user.admin[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "admin_key" {
  for_each = local.admin_users
  user     = aws_iam_user.admin[each.key].name
}