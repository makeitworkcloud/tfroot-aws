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

resource "aws_iam_user" "sops_secrets_operator" {
  name          = "sops-secrets-operator"
  force_destroy = false

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "sops-secrets-operator"
  }
}

resource "aws_iam_user_policy" "sops_secrets_operator_kms" {
  name = "sops-kms-decrypt"
  user = aws_iam_user.sops_secrets_operator.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.sops.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "sops_secrets_operator" {
  user = aws_iam_user.sops_secrets_operator.name
}
