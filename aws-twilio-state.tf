# Stage 1 of the tfroot-twilio state-backend retirement. The state bucket
# moved out of the shared aws_s3_bucket.private class, which keeps
# prevent_destroy and never sets force_destroy; only this dedicated bucket
# becomes destroyable, and only after the move is applied. Bucket deletion
# itself is a separately confirmed stage 2. The role is intentionally limited
# to the exact state object, its lockfile, and the SOPS key required to
# decrypt encrypted provider inputs, and is retained until the stage 2
# cleanup removes it together with the bucket.
resource "aws_s3_bucket" "twilio_state_retired" {
  bucket        = local.twilio_state_bucket
  force_destroy = true

  tags = {
    ManagedBy = "Terraform"
  }
}

moved {
  from = aws_s3_bucket.private["mitw-tf-twilio-infra"]
  to   = aws_s3_bucket.twilio_state_retired
}

resource "aws_s3_bucket_public_access_block" "twilio_state" {
  bucket = aws_s3_bucket.twilio_state_retired.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "twilio_state" {
  bucket = aws_s3_bucket.twilio_state_retired.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "twilio_state" {
  bucket = aws_s3_bucket.twilio_state_retired.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "twilio_state" {
  bucket = aws_s3_bucket.twilio_state_retired.id

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
        Resource = aws_s3_bucket.twilio_state_retired.arn
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
          "${aws_s3_bucket.twilio_state_retired.arn}/${local.twilio_state_key}",
          "${aws_s3_bucket.twilio_state_retired.arn}/${local.twilio_state_key}.tflock"
        ]
      }
    ]
  })
}
