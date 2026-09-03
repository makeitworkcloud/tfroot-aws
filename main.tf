data "sops_file" "secret_vars" {
  source_file = "${path.module}/secrets/secrets.yaml"
}

locals {
  admin_users                 = toset(["svc-terraform-admin"])
  agent_pipe_bucket           = "agent-pipe"
  agent_pipe_delivery_prefix  = "deliveries/"
  channel_project_state_bucket = "mitw-tf-channel-project"
  channel_project_state_keys = toset([
    "tofu/cloudflare/terraform.tfstate",
    "tofu/namecheap/terraform.tfstate",
  ])
  s3_private_buckets = toset([
    "mitw-tf-aws-infra",
    "mitw-tf-channel-project",
    "mitw-tf-cloudflare-infra",
    "mitw-tf-github-repos",
    "mitw-tf-libvirt-infra",
    "mitw-tf-namecheap-infra"
  ])
  s3_public_buckets = toset([])
  s3_web_buckets = toset([
    "makeitwork.cloud",
    "onion.makeitwork.cloud"
  ])
}
