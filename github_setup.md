# GitHub Setup

This file lists the GitHub Environments, Variables, and Secrets needed by the workflows in this repository.

## Quick Summary

There are two setup patterns in this repo:

- Site-level configuration stored as repository variables and secrets.
- Demo-specific overrides stored in GitHub Environments only when a demo needs values that differ from the site-level defaults.

To initialize missing values with the GitHub CLI, use [`scripts/init-gh-vars-secrets.sh`](./scripts/init-gh-vars-secrets.sh). The script is idempotent and does not overwrite existing repository or environment values.

## GitHub Environments To Create

Create these GitHub Environments only if you need demo-specific overrides:

- `dev`
- `staging`
- `main`
- `terraform`

## Repository Variables

Create these repository variables as the site-level defaults:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

Optional repository variables:

- `TRUFFLEHOG_REPOS`

`TRUFFLEHOG_REPOS` is only used by [`.github/workflows/trufflehog-multi-scan.yml`](./.github/workflows/trufflehog-multi-scan.yml). Set it to a newline-separated list of public Git repository URLs.

## Repository Secrets

Create these repository secrets as the site-level defaults:

- `SM_USERNAME`
- `SM_API_KEY`

## Demo-Specific Environments

Only create these environments when the demo needs values that differ from the repository-level defaults.

### `dev`

Used by:

- [`.github/workflows/sm-plugin-jwt-env-aware.yml`](./.github/workflows/sm-plugin-jwt-env-aware.yml) when the branch is `dev`

Override any of these environment variables only if they differ from the site-level values:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

### `staging`

Used by:

- [`.github/workflows/sm-plugin-jwt-env-aware.yml`](./.github/workflows/sm-plugin-jwt-env-aware.yml) when the branch is `staging`

Override any of these environment variables only if they differ from the site-level values:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

### `main`

Used by:

- [`.github/workflows/sm-plugin-jwt-env-aware.yml`](./.github/workflows/sm-plugin-jwt-env-aware.yml) when the branch is `main`

Override any of these environment variables only if they differ from the site-level values:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

### `terraform`

Used by:

- [`.github/workflows/sm-plugin-jwt-terraform-apikey.yml`](./.github/workflows/sm-plugin-jwt-terraform-apikey.yml)

Create or override these environment variables:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`
- `TFVAR_APPLIANCE_URL`
- `TFVAR_ACCOUNT`
- `TFVAR_LOGIN`
- `TFVAR_SSL_CERT`
- `TFVAR_sm_secret_id_1`

Create or override these environment secrets:

- `TFVAR_API_KEY`

## Workflow To Setup Mapping

### No GitHub Environment required

These workflows can use repository-level variables and secrets:

- [`.github/workflows/sm-plugin-jwt.yml`](./.github/workflows/sm-plugin-jwt.yml)
- [`.github/workflows/sm-direct-jwt.yml`](./.github/workflows/sm-direct-jwt.yml)
- [`.github/workflows/sm-plugin-apikey.yml`](./.github/workflows/sm-plugin-apikey.yml)
- [`.github/workflows/trufflehog-single-scan.yml`](./.github/workflows/trufflehog-single-scan.yml)
- [`.github/workflows/trufflehog-multi-scan.yml`](./.github/workflows/trufflehog-multi-scan.yml)

Required repository-level setup by workflow:

- `sm-plugin-jwt`: `SM_URL`, `SM_ACCOUNT`, `SM_JWT_AUTHN_ID`, `SM_SECRET_ID_1`, `SM_SECRET_ID_2`
- `sm-direct-jwt`: `SM_URL`, `SM_ACCOUNT`, `SM_JWT_AUTHN_ID`, `SM_SECRET_ID_1`, `SM_SECRET_ID_2`
- `sm-plugin-apikey`: `SM_URL`, `SM_ACCOUNT`, `SM_SECRET_ID_1`, `SM_SECRET_ID_2`, plus secrets `SM_USERNAME`, `SM_API_KEY`
- `trufflehog-single-scan`: no GitHub variables or secrets required
- `trufflehog-multi-scan`: variable `TRUFFLEHOG_REPOS`

### GitHub Environment required only for overrides

These workflows use GitHub Environments to isolate demo-specific values:

- [`.github/workflows/sm-plugin-jwt-env-aware.yml`](./.github/workflows/sm-plugin-jwt-env-aware.yml)
- [`.github/workflows/sm-plugin-jwt-terraform-apikey.yml`](./.github/workflows/sm-plugin-jwt-terraform-apikey.yml)

## Value Notes

- `SM_URL`: base URL for the Secrets Manager service.
- `SM_ACCOUNT`: Secrets Manager account name.
- `SM_JWT_AUTHN_ID`: JWT authenticator ID used by GitHub OIDC workflows.
- `SM_SECRET_ID_1`: first Secrets Manager variable ID used by the demo.
- `SM_SECRET_ID_2`: second Secrets Manager variable ID used by the demo.
- `SM_USERNAME`: host identity for the API key plugin demo.
- `SM_API_KEY`: API key for the host identity above.
- `TFVAR_APPLIANCE_URL`: Terraform provider appliance URL.
- `TFVAR_ACCOUNT`: Terraform provider account.
- `TFVAR_LOGIN`: Terraform provider login identity.
- `TFVAR_API_KEY`: bootstrap or fallback Terraform provider API key secret.
- `TFVAR_SSL_CERT`: PEM certificate content passed inline to Terraform.
- `TFVAR_sm_secret_id_1`: variable ID read by Terraform through `TF_VAR_conjur_secret_id_1`.

## Notes

- The env-aware workflow resolves `dev`, `staging`, and `main` from the Git branch name. If the branch is not one of those three, the workflow intentionally fails.
- The Terraform workflow currently runs under the GitHub Environment `terraform`.
- The Terraform workflow filename on disk is [`.github/workflows/sm-plugin-jwt-terraform-apikey.yml`](./.github/workflows/sm-plugin-jwt-terraform-apikey.yml).
