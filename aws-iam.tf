resource "aws_iam_user" "admin" {
  for_each      = local.admin_users
  name          = each.value
  force_destroy = false
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_user_policy_attachment" "admin_attach" {
  for_each   = local.admin_users
  user       = aws_iam_user.admin[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "admin_key" {
  for_each = local.admin_users
  user     = aws_iam_user.admin[each.key].name
}

resource "aws_iam_user" "opencode_mcp_bootstrap" {
  name          = "opencode-mcp-bootstrap"
  force_destroy = false

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "opencode-mcp-bootstrap"
  }
}

resource "aws_iam_access_key" "opencode_mcp_bootstrap" {
  user = aws_iam_user.opencode_mcp_bootstrap.name
}

resource "aws_iam_user_policy" "opencode_mcp_bootstrap_assume_role" {
  name = "opencode-mcp-assume-role"
  user = aws_iam_user.opencode_mcp_bootstrap.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.opencode_mcp.arn
      }
    ]
  })
}

# AWS MCP Server OAuth uses the caller's IAM role. The Terraform automation
# and restricted bootstrap users are trusted to assume this purpose-built role.
resource "aws_iam_role" "opencode_mcp" {
  name = "opencode-managed-mcp"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_user.admin["svc-terraform-admin"].arn,
            aws_iam_user.opencode_mcp_bootstrap.arn
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "opencode-managed-mcp"
  }
}

# AWS manages the remote MCP endpoint. This policy permits the role to use its
# OAuth 2.1 sign-in flow without introducing a local MCP proxy.
resource "aws_iam_role_policy_attachment" "opencode_mcp_oauth" {
  role       = aws_iam_role.opencode_mcp.name
  policy_arn = "arn:aws:iam::aws:policy/AWSMCPSignInOAuthAccessPolicy"
}

# ReadOnlyAccess covers AWS resource discovery. The explicit deny below keeps
# OpenTofu state objects outside the agent's trust boundary.
resource "aws_iam_role_policy_attachment" "opencode_mcp_readonly" {
  role       = aws_iam_role.opencode_mcp.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "opencode_mcp_secrets" {
  name = "opencode-managed-mcp-secrets"
  role = aws_iam_role.opencode_mcp.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadSecretValues"
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Resource = "*"
      },
      {
        Sid      = "DecryptSecretsManagerSecrets"
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = "*"
        Condition = {
          StringLike = {
            "kms:ViaService" = "secretsmanager.*.amazonaws.com"
          }
        }
      },
      {
        Sid    = "DenyOpenTofuStateObjectReads"
        Effect = "Deny"
        Action = ["s3:GetObject"]
        Resource = [
          for bucket in local.s3_private_buckets : "arn:aws:s3:::${bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "sops_secrets_operator" {
  name          = "sops-secrets-operator"
  force_destroy = false

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "sops-secrets-operator"
  }
}

resource "aws_iam_user_policy" "sops_secrets_operator_kms" {
  name = "sops-kms-decrypt"
  user = aws_iam_user.sops_secrets_operator.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.sops.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "sops_secrets_operator" {
  user = aws_iam_user.sops_secrets_operator.name
}
