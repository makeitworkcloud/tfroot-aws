# Allows only the central repository-sync workflow on tfroot-github/main to
# retrieve the existing organization GitHub App key. The App opens protected
# branch pull requests; it never writes target default branches directly.
resource "aws_iam_role" "github_actions_repository_sync" {
  name = "github-actions-repository-sync"

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
            "token.actions.githubusercontent.com:sub" = "repo:makeitworkcloud/tfroot-github:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "repository-sync-prs"
  }
}

resource "aws_iam_role_policy" "github_actions_repository_sync" {
  name = "read-repository-sync-github-app-key"
  role = aws_iam_role.github_actions_repository_sync.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadRepositorySyncGitHubAppKey"
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
