output "hero_host_config_sops_kms_key_arn" {
  description = "Dedicated KMS recipient for hero-host-config SOPS data"
  value       = aws_kms_key.hero_host_config_sops.arn
}

output "hero_host_config_github_actions_sops_role_arn" {
  description = "Main-only GitHub Actions OIDC role for hero-host-config SOPS decryption"
  value       = aws_iam_role.github_actions_hero_host_config_sops.arn
}
