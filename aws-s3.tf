resource "aws_s3_bucket" "private" {
  for_each = local.s3_private_buckets
  bucket   = each.value

  tags = {
    ManagedBy = "Terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# channel-project uses a dedicated, versioned state bucket. Its two state keys
# are consumed only by the project-specific OpenTofu roots through GitHub OIDC.
resource "aws_s3_bucket_public_access_block" "channel_project_state" {
  bucket = aws_s3_bucket.private[local.channel_project_state_bucket].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "channel_project_state" {
  bucket = aws_s3_bucket.private[local.channel_project_state_bucket].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "channel_project_state" {
  bucket = aws_s3_bucket.private[local.channel_project_state_bucket].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "channel_project_state" {
  bucket = aws_s3_bucket.private[local.channel_project_state_bucket].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "public" {
  for_each = local.s3_public_buckets
  bucket   = each.value

  tags = {
    ManagedBy = "Terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  for_each                = aws_s3_bucket.public
  bucket                  = each.value.bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public" {
  for_each = aws_s3_bucket.public

  bucket = each.value.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${each.value.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "web" {
  for_each = local.s3_web_buckets
  bucket   = each.value

  tags = {
    ManagedBy = "Terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# S3 website endpoints cannot authenticate object requests. This access block
# permits public controls; the following policy grants anonymous GetObject.
resource "aws_s3_bucket_public_access_block" "web" {
  for_each                = aws_s3_bucket.web
  bucket                  = each.value.bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "web" {
  for_each = aws_s3_bucket.web

  bucket = each.value.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${each.value.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "web" {
  for_each = aws_s3_bucket.web

  bucket = each.value.bucket

  index_document {
    suffix = "index.html"
  }
}

# agent-pipe contains only short-lived, non-secret files intended for a user to
# download through a presigned URL. It is intentionally separate from the
# OpenTofu state buckets listed in local.s3_private_buckets.
resource "aws_s3_bucket" "agent_pipe" {
  bucket = local.agent_pipe_bucket

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "agent-artifact-delivery"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "agent_pipe" {
  bucket = aws_s3_bucket.agent_pipe.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "agent_pipe" {
  bucket = aws_s3_bucket.agent_pipe.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "agent_pipe" {
  bucket = aws_s3_bucket.agent_pipe.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "agent_pipe" {
  bucket = aws_s3_bucket.agent_pipe.id

  rule {
    id     = "expire-agent-deliveries"
    status = "Enabled"

    filter {
      prefix = local.agent_pipe_delivery_prefix
    }

    expiration {
      days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}
