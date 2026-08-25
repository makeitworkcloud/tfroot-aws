data "aws_caller_identity" "current" {}

# Batch inference (50% discount vs on-demand) requires a dedicated service
# role: CreateModelInvocationJob takes a roleArn that Bedrock assumes for S3
# input/output access. The opencode user below gets iam:PassRole on it.
resource "aws_s3_bucket" "bedrock_batch" {
  bucket = "mitw-bedrock-batch"

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "bedrock-batch-inference"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "bedrock_batch" {
  bucket                  = aws_s3_bucket.bedrock_batch.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "bedrock_batch" {
  name = "bedrock-batch-inference"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:model-invocation-job/*"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "bedrock-batch-inference"
  }
}

resource "aws_iam_role_policy" "bedrock_batch_s3" {
  name = "bedrock-batch-s3"
  role = aws_iam_role.bedrock_batch.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.bedrock_batch.arn,
          "${aws_s3_bucket.bedrock_batch.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Newer Anthropic models (Opus 4.x) reject base model IDs and must be called
# through inference profiles, so both resource types are granted everywhere.
resource "aws_iam_role_policy" "bedrock_batch_invoke" {
  name = "bedrock-batch-invoke"
  role = aws_iam_role.bedrock_batch.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InvokeAnthropicModels"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/anthropic.*",
          "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:inference-profile/*.anthropic.*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "bedrock_opencode" {
  name          = "opencode-bedrock"
  force_destroy = false

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "opencode-bedrock"
  }
}

resource "aws_iam_user_policy" "bedrock_opencode" {
  name = "bedrock-invoke"
  user = aws_iam_user.bedrock_opencode.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InvokeAnthropicModels"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/anthropic.*",
          "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:inference-profile/*.anthropic.*"
        ]
      },
      {
        Sid      = "DiscoverInferenceProfiles"
        Effect   = "Allow"
        Action   = ["bedrock:ListInferenceProfiles"]
        Resource = "*"
      },
      {
        Sid    = "ManageBatchJobs"
        Effect = "Allow"
        Action = [
          "bedrock:CreateModelInvocationJob",
          "bedrock:GetModelInvocationJob",
          "bedrock:StopModelInvocationJob",
          "bedrock:TagResource"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/anthropic.*",
          "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:inference-profile/*.anthropic.*",
          "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:model-invocation-job/*"
        ]
      },
      {
        Sid      = "ListBatchJobs"
        Effect   = "Allow"
        Action   = ["bedrock:ListModelInvocationJobs"]
        Resource = "*"
      },
      {
        # Model access page is retired: first invoke auto-subscribes the
        # account, which Bedrock performs via AWS Marketplace on the caller's
        # behalf. Without this, new models fail with a marketplace denial.
        Sid    = "MarketplaceModelSubscription"
        Effect = "Allow"
        Action = [
          "aws-marketplace:ViewSubscriptions",
          "aws-marketplace:Subscribe"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:CalledViaLast" = "bedrock.amazonaws.com"
          }
        }
      },
      {
        Sid    = "BatchDataS3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.bedrock_batch.arn,
          "${aws_s3_bucket.bedrock_batch.arn}/*"
        ]
      },
      {
        Sid      = "PassBatchServiceRole"
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = aws_iam_role.bedrock_batch.arn
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "bedrock.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_access_key" "bedrock_opencode" {
  user = aws_iam_user.bedrock_opencode.name
}
