# Agent Instructions

OpenTofu root for Make IT Work Cloud AWS infrastructure.

Use PR CI plans as authoritative validation. `main` is an apply path after configured environment approval: use scoped branches and PRs, never direct pushes. Do not use state, import, or apply operations as validation.

The shared workflow is owned by `shared-workflows`; the runner image and canonical pre-commit configuration are owned by `images/tfroot-runner`. Keep SOPS data encrypted and never expose state, credentials, decrypted values, or sensitive plan output.
