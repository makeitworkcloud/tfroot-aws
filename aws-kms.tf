resource "aws_kms_key" "sops" {
  description             = "SOPS encryption key for Make IT Work Cloud infrastructure secrets"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "sops"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "sops" {
  name          = "alias/makeitworkcloud/sops"
  target_key_id = aws_kms_key.sops.key_id
}
