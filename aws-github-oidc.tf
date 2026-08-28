resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "github_actions_sops_kms" {
  name = "github-actions-sops-kms"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:makeitworkcloud/tfroot-aws:*",
              "repo:makeitworkcloud/tfroot-cloudflare:*",
              "repo:makeitworkcloud/tfroot-github:*",
              "repo:makeitworkcloud/tfroot-libvirt:*"
            ]
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy" "github_actions_sops_kms" {
  name = "sops-kms"
  role = aws_iam_role.github_actions_sops_kms.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ]
        Resource = aws_kms_key.sops.arn
      }
    ]
  })
}
