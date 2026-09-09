# channel-project GitHub OIDC role split

Status: **staged migration.** This document distinguishes verified current
configuration from intended subsequent changes. It describes source code and
workflow references only; it does not claim live AWS state.

## Current bootstrap ownership

`tfroot-aws` owns the account GitHub Actions OIDC provider, the
channel-project OpenTofu state bucket and state-key access, the roles consumed
by channel-project workflows, and the public `orthodox.channel` S3 website
bucket. `channel-project` owns the private rollback origin, CloudFront
resources, logging delivery, and ACM request through `tofu/aws/`.

The current roles are:

| Role | Trust | Purpose |
| --- | --- | --- |
| `github-actions-channel-project-site-infrastructure` | Any channel-project subject | Current OpenTofu caller for both pull-request plans and main applies. It includes state access and the existing private-origin, CloudFront, and logging permissions. |
| `github-actions-channel-project-site-deploy` | `channel-project` `main` only | Explicit static-site publication to the private rollback and public website buckets. It is separate from OpenTofu state and infrastructure management. |

`channel-project/.github/workflows/opentofu.yml` currently passes the
infrastructure role to the shared OpenTofu workflow for pull requests and
main pushes. `site-deploy.yml` is separately manually dispatched from `main`
and assumes the deployment role.

## This stage

This change adds `github-actions-channel-project-site-apply`, a new role whose
trust is restricted to the exact channel-project `main` OIDC subject. Its
inline policy intentionally reuses the existing infrastructure-policy document
so that it can become the main apply caller without broadening the current
permission set.

The new role is not used by a workflow in this stage. Creating it first keeps
the current plan path intact while allowing a later caller change to select
roles by event.

## Intended subsequent stages

1. Verify that the environment-gated reusable apply emits the exact
   `main`-branch OIDC subject trusted by the new role. Do not weaken the trust
   condition to a wildcard.
2. Give the new role its own policy document with the current apply-permission
   contract. Do this before changing the legacy role: its current policy
   reference is intentionally temporary.
3. Update `channel-project` so pull-request plans use the explicitly
   plan-scoped role while main applies use the new main-only apply role.
4. After that consumer change and its main apply are verified, narrow the
   legacy any-ref role to the read and state-lock permissions required for
   plans.
5. In later separately reviewed changes, grant only the main-only apply role
   the public-origin transfer and dynamic-index identity permissions required
   for Orthodox Channel. Do not grant those permissions to the any-ref plan
   role.
6. Retain the separately main-only deployment role for static publication. It
   must not gain OpenTofu state, infrastructure, or Hero runtime-credential
   access.

## Delivery and safety

Pull-request CI validates OpenTofu configuration and produces a plan; it does
not apply the new role or prove downstream workflow selection. Merging and the
environment-gated `main` apply are separate confirmation gates. The existing
public bucket, its publication path, DNS, Cloudflare, and Hero remain
unchanged by this stage.

No plaintext credentials, decrypted SOPS values, state, or runtime secrets
belong in this root or this document.
