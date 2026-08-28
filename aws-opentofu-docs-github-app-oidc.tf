# Allows trusted same-repository OpenTofu pull requests to mint a short-lived
# GitHub App token for committing generated Terraform documentation. App-authored
# generated-doc commits trigger normal pull-request validation on their resulting
# SHA, unlike commits made with GITHUB_TOKEN.
resource "aws_iam_role" "github_actions_opentofu_docs" {
  name = "github-actions-opentofu-docs"

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
              "repo:makeitworkcloud/tfroot-aws:pull_request",
              "repo:makeitworkcloud/tfroot-cloudflare:pull_request",
              "repo:makeitworkcloud/tfroot-gcp:pull_request",
              "repo:makeitworkcloud/tfroot-github:pull_request",
              "repo:makeitworkcloud/tfroot-libvirt:pull_request",
              "repo:makeitworkcloud/tfroot-namecheap:pull_request"
            ]
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "opentofu-generated-docs"
  }
}

resource "aws_iam_role_policy" "github_actions_opentofu_docs" {
  name = "read-opentofu-docs-github-app-key"
  role = aws_iam_role.github_actions_opentofu_docs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOpenTofuDocsGitHubAppKey"
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws:secretsmanager:us-west-2:332355796717:secret:xnoto-s-chart-updater-github-app-private-key-qP4Qr3"
      }
    ]
  })
}
