# CloudFront standard logging v2 is managed by the channel-project AWS root
# through CloudWatch Logs delivery resources in us-east-1. Keep this narrowly
# scoped role policy separate from S3/CloudFront distribution management.
resource "aws_iam_role_policy" "github_actions_channel_project_site_log_delivery" {
  name = "channel-project-site-log-delivery"
  role = aws_iam_role.github_actions_channel_project_site_infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ManageSiteCloudFrontLogDelivery"
        Effect = "Allow"
        Action = [
          "logs:CreateDelivery",
          "logs:DeleteDelivery",
          "logs:DeleteDeliveryDestination",
          "logs:DeleteDeliverySource",
          "logs:GetDelivery",
          "logs:GetDeliveryDestination",
          "logs:GetDeliverySource",
          "logs:ListTagsForResource",
          "logs:PutDeliveryDestination",
          "logs:PutDeliverySource",
          "logs:TagResource",
          "logs:UntagResource",
          "logs:UpdateDelivery"
        ]
        Resource = "*"
      }
    ]
  })
}
