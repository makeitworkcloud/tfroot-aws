# The existing channel-project infrastructure role currently supports same-repository pull-request plans. This new role is restricted to main and deliberately reuses its current infrastructure policy until the caller has migrated to event-specific roles.
resource "aws_iam_role" "github_actions_channel_project_site_apply" {
  name = "github-actions-channel-project-site-apply"

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
            "token.actions.githubusercontent.com:sub" = "repo:makeitworkcloud@195502628/channel-project@1355525330:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "channel-project-site-infrastructure-apply"
  }
}

resource "aws_iam_role_policy" "github_actions_channel_project_site_apply" {
  name   = "channel-project-site-infrastructure-apply"
  role   = aws_iam_role.github_actions_channel_project_site_apply.id
  policy = aws_iam_role_policy.github_actions_channel_project_site_infrastructure.policy
}
