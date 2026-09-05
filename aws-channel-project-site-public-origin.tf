# The public Orthodox Channel website origin follows the existing
# makeitwork.cloud S3 website class. It is intentionally separate from the
# private OAC-protected artifact bucket, which remains the rollback origin.
# Publication remains limited to channel-project's main-only deployment role.
resource "aws_iam_role_policy" "github_actions_channel_project_site_public_origin" {
  name = "channel-project-site-public-origin"
  role = aws_iam_role.github_actions_channel_project_site_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListPublicSiteOrigin"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.web["orthodox.channel"].arn
      },
      {
        Sid    = "PublishPublicSiteAssets"
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject",
        ]
        Resource = "${aws_s3_bucket.web["orthodox.channel"].arn}/*"
      },
    ]
  })
}
