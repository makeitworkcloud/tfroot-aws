<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_sops"></a> [sops](#provider\_sops) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_iam_access_key.admin_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.bedrock_opencode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.opencode_mcp_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.sops_secrets_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.bedrock_batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_channel_project_site_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_channel_project_site_infrastructure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_channel_project_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_hero_host_config_sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_sops_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_twilio_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_xnoto_dev_site_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.opencode_mcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.bedrock_batch_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.bedrock_batch_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_channel_project_site_acm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_channel_project_site_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_channel_project_site_infrastructure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_channel_project_site_log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_channel_project_site_public_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_channel_project_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_hero_host_config_sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_sops_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_twilio_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_xnoto_dev_site_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.opencode_mcp_agent_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.opencode_mcp_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.opencode_mcp_oauth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.opencode_mcp_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.bedrock_opencode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.opencode_mcp_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.sops_secrets_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.bedrock_opencode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.opencode_mcp_bootstrap_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.sops_secrets_operator_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy_attachment.admin_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_kms_alias.hero_host_config_sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.hero_host_config_sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.agent_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.bedrock_batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.agent_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.agent_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.channel_project_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.twilio_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.agent_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.bedrock_batch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.channel_project_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.twilio_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.agent_pipe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.channel_project_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.twilio_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.channel_project_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.twilio_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [sops_file.secret_vars](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_admin_access_keys"></a> [admin\_access\_keys](#output\_admin\_access\_keys) | Admin IAM user access keys |
| <a name="output_agent_pipe_bucket_name"></a> [agent\_pipe\_bucket\_name](#output\_agent\_pipe\_bucket\_name) | Private S3 bucket for short-lived agent-to-user artifact delivery |
| <a name="output_agent_pipe_delivery_prefix"></a> [agent\_pipe\_delivery\_prefix](#output\_agent\_pipe\_delivery\_prefix) | Object-key prefix permitted for managed OpenCode artifact delivery |
| <a name="output_bedrock_batch_bucket_name"></a> [bedrock\_batch\_bucket\_name](#output\_bedrock\_batch\_bucket\_name) | S3 bucket for Bedrock batch inference input and output data |
| <a name="output_bedrock_batch_service_role_arn"></a> [bedrock\_batch\_service\_role\_arn](#output\_bedrock\_batch\_service\_role\_arn) | Service role ARN to pass as roleArn when creating Bedrock batch inference jobs |
| <a name="output_bedrock_opencode_access_key"></a> [bedrock\_opencode\_access\_key](#output\_bedrock\_opencode\_access\_key) | Access key for OpenCode to invoke Anthropic models via AWS Bedrock |
| <a name="output_bedrock_opencode_iam_user_arn"></a> [bedrock\_opencode\_iam\_user\_arn](#output\_bedrock\_opencode\_iam\_user\_arn) | IAM user ARN for OpenCode Bedrock access |
| <a name="output_channel_project_github_actions_role_arn"></a> [channel\_project\_github\_actions\_role\_arn](#output\_channel\_project\_github\_actions\_role\_arn) | GitHub OIDC role for channel-project OpenTofu state and SOPS decrypt access |
| <a name="output_channel_project_site_deploy_role_arn"></a> [channel\_project\_site\_deploy\_role\_arn](#output\_channel\_project\_site\_deploy\_role\_arn) | GitHub OIDC role for publishing channel-project static-site assets from main |
| <a name="output_channel_project_site_infrastructure_role_arn"></a> [channel\_project\_site\_infrastructure\_role\_arn](#output\_channel\_project\_site\_infrastructure\_role\_arn) | GitHub OIDC role for channel-project static-site OpenTofu roots |
| <a name="output_channel_project_state_bucket_name"></a> [channel\_project\_state\_bucket\_name](#output\_channel\_project\_state\_bucket\_name) | Versioned private S3 bucket for channel-project OpenTofu state |
| <a name="output_github_actions_sops_kms_role_arn"></a> [github\_actions\_sops\_kms\_role\_arn](#output\_github\_actions\_sops\_kms\_role\_arn) | IAM role ARN for GitHub Actions SOPS KMS access |
| <a name="output_hero_host_config_github_actions_sops_role_arn"></a> [hero\_host\_config\_github\_actions\_sops\_role\_arn](#output\_hero\_host\_config\_github\_actions\_sops\_role\_arn) | Main-only GitHub Actions OIDC role for hero-host-config SOPS decryption |
| <a name="output_hero_host_config_sops_kms_key_arn"></a> [hero\_host\_config\_sops\_kms\_key\_arn](#output\_hero\_host\_config\_sops\_kms\_key\_arn) | Dedicated KMS recipient for hero-host-config SOPS data |
| <a name="output_opencode_mcp_bootstrap_access_key"></a> [opencode\_mcp\_bootstrap\_access\_key](#output\_opencode\_mcp\_bootstrap\_access\_key) | Access key for the restricted OpenCode MCP bootstrap user |
| <a name="output_opencode_mcp_role_arn"></a> [opencode\_mcp\_role\_arn](#output\_opencode\_mcp\_role\_arn) | IAM role ARN for the managed AWS MCP Server |
| <a name="output_sops_kms_key_arn"></a> [sops\_kms\_key\_arn](#output\_sops\_kms\_key\_arn) | KMS key ARN for future SOPS AWS KMS recipients |
| <a name="output_sops_secrets_operator_access_key"></a> [sops\_secrets\_operator\_access\_key](#output\_sops\_secrets\_operator\_access\_key) | Access key for the k3s sops-secrets-operator to decrypt SOPS AWS KMS secrets |
| <a name="output_sops_secrets_operator_iam_user_arn"></a> [sops\_secrets\_operator\_iam\_user\_arn](#output\_sops\_secrets\_operator\_iam\_user\_arn) | IAM user ARN for the k3s sops-secrets-operator |
| <a name="output_twilio_github_actions_state_role_arn"></a> [twilio\_github\_actions\_state\_role\_arn](#output\_twilio\_github\_actions\_state\_role\_arn) | GitHub OIDC role for tfroot-twilio OpenTofu state and SOPS decrypt access |
| <a name="output_twilio_state_bucket_name"></a> [twilio\_state\_bucket\_name](#output\_twilio\_state\_bucket\_name) | Versioned private S3 bucket for tfroot-twilio OpenTofu state |
| <a name="output_web_bucket_endpoints"></a> [web\_bucket\_endpoints](#output\_web\_bucket\_endpoints) | Website endpoints for public web S3 buckets |
| <a name="output_xnoto_dev_site_deploy_role_arn"></a> [xnoto\_dev\_site\_deploy\_role\_arn](#output\_xnoto\_dev\_site\_deploy\_role\_arn) | GitHub OIDC role for publishing xnoto.dev static-site assets from main |
<!-- END_TF_DOCS -->

## AWS Bedrock batch inference (50% discount)

Batch inference bills at 50% of the on-demand Standard tier for
asynchronous workloads (results within 24h; small jobs finish in minutes).
Deployed resources: the `opencode-bedrock` IAM user, the
`bedrock-batch-inference` service role, and the `mitw-bedrock-batch` bucket.

1. Build a JSONL input file with **at least 100 records** (one model per job):

   ```
   {"recordId":"task-001","modelInput":{"anthropic_version":"bedrock-2023-05-31","max_tokens":2048,"messages":[{"role":"user","content":"..."}]}}
   ```

2. Upload and submit (use a per-job input prefix so only this job's files
   are processed):

   ```bash
   export AWS_PROFILE=opencode-bedrock AWS_REGION=us-west-2
   aws s3 cp tasks.jsonl s3://mitw-bedrock-batch/input/my-job/tasks.jsonl
   aws bedrock create-model-invocation-job \
     --job-name "my-job-$(date +%s)" \
     --role-arn "$(AWS_PROFILE=makeitwork tofu output -raw bedrock_batch_service_role_arn)" \
     --model-id us.anthropic.claude-opus-4-6-v1 \
     --input-data-config "s3InputDataConfig={s3Uri=s3://mitw-bedrock-batch/input/my-job/}" \
     --output-data-config "s3OutputDataConfig={s3Uri=s3://mitw-bedrock-batch/output/}"
   ```

3. Monitor until `Completed` (Submitted → Validating → Scheduled → InProgress):

   ```bash
   aws bedrock get-model-invocation-job --job-identifier "<jobArn>" --query status --output text
   ```

4. Collect results and join outputs to inputs on `recordId`:

   ```bash
   aws s3 cp s3://mitw-bedrock-batch/output/<job-id>/ . --recursive
   ```

Verify the discount in Cost Explorer (Service: Amazon Bedrock, group by
Usage Type): batch jobs appear as Batch usage at 50% of Standard.
Interactive sessions remain on-demand; use batch for bulk, latency-tolerant
work only. Models must be invocable by the account (currently Opus 4.6/4.5,
Sonnet 4.6/4.5).
