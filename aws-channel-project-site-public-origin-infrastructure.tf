# Bootstrap authorization for the channel-project root. This remains in tfroot-aws because it owns the AWS GitHub OIDC provider and the project-specific role; it does not own the Orthodox Channel public-origin resources themselves.
resource "aws_iam_role_policy" "github_actions_channel_project_site_public_origin_infrastructure" {
  name = "channel-project-site-public-origin-infrastructure"
  role = aws_iam_role.github_actions_channel_project_site_infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ManagePublicSiteOriginConfiguration"
        Effect = "Allow"
        Action = [
          "s3:DeleteBucketPolicy",
          "s3:DeleteBucketWebsite",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketLocation",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:GetBucketPolicy",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketWebsite",
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
          "s3:PutBucketOwnershipControls",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutBucketWebsite",
          "s3:PutEncryptionConfiguration",
          "s3:PutLifecycleConfiguration"
        ]
        Resource = "arn:aws:s3:::orthodox.channel"
      },
      {
        Sid    = "ManageHeroDynamicIndexWriterIdentity"
        Effect = "Allow"
        Action = [
          "iam:CreateAccessKey",
          "iam:CreateUser",
          "iam:DeleteAccessKey",
          "iam:DeleteUser",
          "iam:DeleteUserPolicy",
          "iam:GetUser",
          "iam:GetUserPolicy",
          "iam:ListAccessKeys",
          "iam:ListUserPolicies",
          "iam:ListUserTags",
          "iam:PutUserPolicy",
          "iam:TagUser",
          "iam:UntagUser"
        ]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/orthodox-channel-hero-index-writer"
      }
    ]
  })
}
