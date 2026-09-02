output "admin_access_keys" {
  description = "Admin IAM user access keys"
  value = { for user, key in aws_iam_access_key.admin_key : user => {
    access_key_id     = key.id
    secret_access_key = key.secret
  } }
  sensitive = true
}

output "opencode_mcp_bootstrap_access_key" {
  description = "Access key for the restricted OpenCode MCP bootstrap user"
  value = {
    access_key_id     = aws_iam_access_key.opencode_mcp_bootstrap.id
    secret_access_key = aws_iam_access_key.opencode_mcp_bootstrap.secret
  }
  sensitive = true
}

output "web_bucket_endpoints" {
  value = {
    for k, b in aws_s3_bucket.web :
    k => aws_s3_bucket_website_configuration.web[k].website_endpoint
  }
  description = "Website endpoints for public web S3 buckets"
}

output "agent_pipe_bucket_name" {
  description = "Private S3 bucket for short-lived agent-to-user artifact delivery"
  value       = aws_s3_bucket.agent_pipe.bucket
}

output "agent_pipe_delivery_prefix" {
  description = "Object-key prefix permitted for managed OpenCode artifact delivery"
  value       = local.agent_pipe_delivery_prefix
}

output "sops_kms_key_arn" {
  description = "KMS key ARN for future SOPS AWS KMS recipients"
  value       = aws_kms_key.sops.arn
}

output "github_actions_sops_kms_role_arn" {
  description = "IAM role ARN for GitHub Actions SOPS KMS access"
  value       = aws_iam_role.github_actions_sops_kms.arn
}

output "opencode_mcp_role_arn" {
  description = "IAM role ARN for the managed AWS MCP Server"
  value       = aws_iam_role.opencode_mcp.arn
}

output "sops_secrets_operator_access_key" {
  description = "Access key for the k3s sops-secrets-operator to decrypt SOPS AWS KMS secrets"
  value = {
    access_key_id     = aws_iam_access_key.sops_secrets_operator.id
    secret_access_key = aws_iam_access_key.sops_secrets_operator.secret
  }
  sensitive = true
}

output "sops_secrets_operator_iam_user_arn" {
  description = "IAM user ARN for the k3s sops-secrets-operator"
  value       = aws_iam_user.sops_secrets_operator.arn
}

output "bedrock_opencode_access_key" {
  description = "Access key for OpenCode to invoke Anthropic models via AWS Bedrock"
  value = {
    access_key_id     = aws_iam_access_key.bedrock_opencode.id
    secret_access_key = aws_iam_access_key.bedrock_opencode.secret
  }
  sensitive = true
}

output "bedrock_opencode_iam_user_arn" {
  description = "IAM user ARN for OpenCode Bedrock access"
  value       = aws_iam_user.bedrock_opencode.arn
}

output "bedrock_batch_service_role_arn" {
  description = "Service role ARN to pass as roleArn when creating Bedrock batch inference jobs"
  value       = aws_iam_role.bedrock_batch.arn
}

output "bedrock_batch_bucket_name" {
  description = "S3 bucket for Bedrock batch inference input and output data"
  value       = aws_s3_bucket.bedrock_batch.bucket
}
