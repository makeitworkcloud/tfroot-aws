# tfroot-twilio receives an isolated state bucket and OIDC role. The role
# is intentionally limited to the exact state object, its lockfile, and the
# SOPS key required to decrypt future encrypted provider inputs.
resource "aws_s3_bucket_public_access_block" "twilio_state" {
  bucket = aws_s3_bucket.private[local.twilio_state_bucket].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "twilio_state" {
  bucket = aws_s3_bucket.private[local.twilio_state_bucket].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "twilio_state" {
  bucket = aws_s3_bucket.private[local.twilio_state_bucket].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "twilio_state" {
  bucket = aws_s3_bucket.private[local.twilio_state_bucket].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "github_actions_twilio_state" {
  name = "github-actions-twilio-state"

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
            "token.actions.githubusercontent.com:sub" = "repo:makeitworkcloud@195502628/tfroot-twilio@1356437102:*"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "twilio-opentofu-state"
  }
}

resource "aws_iam_role_policy" "github_actions_twilio_state" {
  name = "twilio-opentofu-state"
  role = aws_iam_role.github_actions_twilio_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DecryptTwilioSops"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.sops.arn
      },
      {
        Sid      = "ListTwilioStateBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.private[local.twilio_state_bucket].arn
      },
      {
        Sid    = "ManageTwilioStateObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.private[local.twilio_state_bucket].arn}/${local.twilio_state_key}",
          "${aws_s3_bucket.private[local.twilio_state_bucket].arn}/${local.twilio_state_key}.tflock"
        ]
      }
    ]
  })
}
