data "sops_file" "secret_vars" {
  source_file = "${path.module}/secrets/secrets.yaml"
}

locals {
  admin_users = toset(["svc-terraform-admin"])
  s3_private_buckets = toset([
    "mitw-tf-aws-infra",
    "mitw-tf-cloudflare-infra",
    "mitw-tf-github-repos",
    "mitw-tf-libvirt-infra"
  ])
  s3_public_buckets = toset([])
  s3_web_buckets = toset([
    "makeitwork.cloud",
    "onion.makeitwork.cloud"
  ])
}