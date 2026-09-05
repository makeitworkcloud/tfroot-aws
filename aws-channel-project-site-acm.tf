# This scoped role policy is separate from S3/CloudFront distribution management.
# It grants only the ACM lifecycle actions required by channel-project's
# us-east-1 CloudFront viewer certificate.
resource "aws_iam_role_policy" "github_actions_channel_project_site_acm" {
  name = "channel-project-site-acm"
  role = aws_iam_role.github_actions_channel_project_site_infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "RequestSiteViewerCertificate"
        Effect   = "Allow"
        Action   = ["acm:RequestCertificate"]
        Resource = "*"
      },
      {
        Sid    = "ManageSiteViewerCertificate"
        Effect = "Allow"
        Action = [
          "acm:AddTagsToCertificate",
          "acm:DeleteCertificate",
          "acm:DescribeCertificate",
          "acm:ListTagsForCertificate",
          "acm:RemoveTagsFromCertificate"
        ]
        Resource = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/*"
      }
    ]
  })
}
