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
              "repo:makeitworkcloud@195502628/tfroot-twilio@1356437102:*"
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
# channel-project workflows can read or write the project's OpenTofu states.
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

# This role is for channel-project OpenTofu roots. It includes that
# repository's state access and only the AWS control-plane permissions needed
# to own the private holding-site origin and its CloudFront distribution.
resource "aws_iam_role" "github_actions_channel_project_site_infrastructure" {
  name = "github-actions-channel-project-site-infrastructure"

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
            "token.actions.githubusercontent.com:sub" = "repo:makeitworkcloud@195502628/channel-project@1355525330:*"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "channel-project-site-infrastructure"
  }
}

resource "aws_iam_role_policy" "github_actions_channel_project_site_infrastructure" {
  name = "channel-project-site-infrastructure"
  role = aws_iam_role.github_actions_channel_project_site_infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
      },
      {
        Sid    = "DiscoverBuckets"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      },
      {
        Sid    = "CreateSiteBuckets"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket"
        ]
        Resource = "*"
      },
      {
        Sid    = "ManageSiteBuckets"
        Effect = "Allow"
        Action = [
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketLocation",
          "s3:GetBucketLogging",
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
          "s3:PutBucketAcl",
          "s3:PutBucketOwnershipControls",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutEncryptionConfiguration",
          "s3:PutLifecycleConfiguration"
        ]
        Resource = [
          "arn:aws:s3:::${local.channel_project_site_bucket}",
          "arn:aws:s3:::${local.channel_project_site_log_bucket}"
        ]
      },
      {
        Sid    = "ManageSiteOriginAccessControl"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateOriginAccessControl",
          "cloudfront:DeleteOriginAccessControl",
          "cloudfront:GetOriginAccessControl",
          "cloudfront:GetOriginAccessControlConfig",
          "cloudfront:ListOriginAccessControls",
          "cloudfront:UpdateOriginAccessControl"
        ]
        Resource = "*"
      },
      {
        Sid    = "ManageSiteDistribution"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateDistribution",
          "cloudfront:DeleteDistribution",
          "cloudfront:GetDistribution",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudfront:ListTagsForResource",
          "cloudfront:TagResource",
          "cloudfront:UntagResource",
          "cloudfront:UpdateDistribution"
        ]
        Resource = "*"
      },
      {
        Sid    = "ReadManagedCloudFrontPolicies"
        Effect = "Allow"
        Action = [
          "cloudfront:GetCachePolicy",
          "cloudfront:GetResponseHeadersPolicy",
          "cloudfront:ListCachePolicies",
          "cloudfront:ListResponseHeadersPolicies"
        ]
        Resource = "*"
      },
      {
        Sid    = "ManageVendedLogDeliveries"
        Effect = "Allow"
        Action = [
          "logs:CreateDelivery",
          "logs:DeleteDelivery",
          "logs:DeleteDeliveryDestination",
          "logs:DeleteDeliveryDestinationPolicy",
          "logs:DeleteDeliverySource",
          "logs:GetDelivery",
          "logs:GetDeliveryDestination",
          "logs:GetDeliveryDestinationPolicy",
          "logs:GetDeliverySource",
          "logs:PutDeliveryDestination",
          "logs:PutDeliveryDestinationPolicy",
          "logs:PutDeliverySource",
          "logs:UpdateDeliveryConfiguration"
        ]
        Resource = [
          "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:delivery:*",
          "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:delivery-source:*",
          "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:delivery-destination:*"
        ]
      },
      {
        Sid    = "DescribeVendedLogDeliveries"
        Effect = "Allow"
        Action = [
          "logs:DescribeConfigurationTemplates",
          "logs:DescribeDeliveries",
          "logs:DescribeDeliveryDestinations",
          "logs:DescribeDeliverySources"
        ]
        Resource = "*"
      },
      {
        Sid      = "AuthorizeSiteVendedLogDelivery"
        Effect   = "Allow"
        Action   = ["cloudfront:AllowVendedLogDeliveryForResource"]
        Resource = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"]
      }
    ]
  })
}

# Site publication is separate from infrastructure management and is trusted
# only from channel-project's main branch. It cannot manage state or create
# infrastructure resources.
resource "aws_iam_role" "github_actions_channel_project_site_deploy" {
  name = "github-actions-channel-project-site-deploy"

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
    Purpose   = "channel-project-site-deployment"
  }
}

resource "aws_iam_role_policy" "github_actions_channel_project_site_deploy" {
  name = "channel-project-site-deployment"
  role = aws_iam_role.github_actions_channel_project_site_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListSiteAssetBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${local.channel_project_site_bucket}"
      },
      {
        Sid    = "PublishSiteAssets"
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${local.channel_project_site_bucket}/*"
      },
      {
        Sid      = "InvalidateSiteDistribution"
        Effect   = "Allow"
        Action   = ["cloudfront:CreateInvalidation"]
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"
      }
    ]
  })
}
