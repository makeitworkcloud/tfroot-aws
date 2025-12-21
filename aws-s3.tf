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
  bucket                  = each.value.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public" {
  for_each = aws_s3_bucket.public

  bucket = each.value.id

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

# Make "web" buckets publicly accessible
resource "aws_s3_bucket_public_access_block" "web" {
  for_each                = aws_s3_bucket.web
  bucket                  = each.value.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "web" {
  for_each = aws_s3_bucket.web

  bucket = each.value.id

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

  bucket = each.value.id

  index_document {
    suffix = "index.html"
  }
}
