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
              "repo:makeitworkcloud/tfroot-libvirt:*",
              "repo:makeitworkcloud@195502628/tfroot-namecheap@1349145005:*",
              "repo:makeitworkcloud/tfroot-twilio:*"
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

# This role is intentionally separate from the multi-root SOPS role. Only
# channel-project workflows can read or write the two project state objects.
resource "aws_iam_role" "github_actions_channel_project_state" {
  name = "github-actions-channel-project-state"

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
            # This repository emits the organization/repository ID subject form.
            "token.actions.githubusercontent.com:sub" = "repo:makeitworkcloud@195502628/channel-project@1355525330:*"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "channel-project-opentofu-state"
  }
}

resource "aws_iam_role_policy" "github_actions_channel_project_state" {
  name = "channel-project-opentofu-state"
  role = aws_iam_role.github_actions_channel_project_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DecryptChannelProjectSops"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.sops.arn
      },
      {
        Sid      = "ListChannelProjectStateBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.private[local.channel_project_state_bucket].arn
      },
      {
        Sid    = "ManageChannelProjectStateObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = concat(
          [for key in local.channel_project_state_keys : "${aws_s3_bucket.private[local.channel_project_state_bucket].arn}/${key}"],
          [for key in local.channel_project_state_keys : "${aws_s3_bucket.private[local.channel_project_state_bucket].arn}/${key}.tflock"],
        )
      }
    ]
  })
}
