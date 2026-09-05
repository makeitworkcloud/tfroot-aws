# hero-host-config is intentionally isolated from the shared multi-root SOPS
# role. Its GitHub Actions deployment workflow can decrypt only its own
# encrypted host-management material on main.
resource "aws_kms_key" "hero_host_config_sops" {
  description             = "SOPS encryption key for Hero host configuration"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "hero-host-config-sops"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "hero_host_config_sops" {
  name          = "alias/makeitworkcloud/hero-host-config/sops"
  target_key_id = aws_kms_key.hero_host_config_sops.key_id
}

resource "aws_iam_role" "github_actions_hero_host_config_sops" {
  name = "github-actions-hero-host-config-sops"

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
            "token.actions.githubusercontent.com:sub" = "repo:makeitworkcloud/hero-host-config:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "hero-host-config-sops"
  }
}

resource "aws_iam_role_policy" "github_actions_hero_host_config_sops" {
  name = "hero-host-config-sops-decrypt"
  role = aws_iam_role.github_actions_hero_host_config_sops.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DecryptHeroHostConfigSops"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.hero_host_config_sops.arn
      }
    ]
  })
}
