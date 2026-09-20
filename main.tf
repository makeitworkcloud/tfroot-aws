data "sops_file" "secret_vars" {
  source_file = "${path.module}/secrets/secrets.yaml"
}

locals {
  admin_users                     = toset(["svc-terraform-admin"])
  agent_pipe_bucket               = "agent-pipe"
  agent_pipe_delivery_prefix      = "deliveries/"
  channel_project_state_bucket    = "mitw-tf-channel-project"
  channel_project_site_bucket     = "orthodox-channel-site-332355796717"
  channel_project_site_log_bucket = "orthodox-channel-site-logs-332355796717"
  twilio_state_bucket             = "mitw-tf-twilio-infra"
  channel_project_state_keys = toset([
    "tofu/aws/terraform.tfstate",
    "tofu/cloudflare/terraform.tfstate",
    "tofu/namecheap/terraform.tfstate",
  ])
  s3_private_buckets = toset([
    "mitw-tf-aws-infra",
    "mitw-tf-channel-project",
    "mitw-tf-cloudflare-infra",
    "mitw-tf-github-repos",
    "mitw-tf-libvirt-infra",
    "mitw-tf-namecheap-infra",
  ])
  s3_public_buckets = toset([])
  s3_web_buckets = toset([
    "makeitwork.cloud",
    "onion.makeitwork.cloud",
    "orthodox.channel",
    "xnoto.dev",
  ])
  # Temporary: keep the retiring twilio bucket denied to the OpenCode MCP
  # role until its deletion is confirmed absent; the deny must never shrink
  # in the same apply as the bucket destroy. Remove this guard and the
  # twilio_state_bucket local only in a follow-up phase after observed
  # bucket absence.
  opentofu_state_guard_buckets = concat(
    [for bucket in local.s3_private_buckets : bucket],
    [local.twilio_state_bucket],
  )
}
