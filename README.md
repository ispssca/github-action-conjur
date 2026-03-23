# GitHub Actions Demos

This repository is a collection of standalone GitHub Actions demos for Secrets Manager and TruffleHog. Note: Secrets Manager was previously called Conjur. Each workflow is documented as an independent demo so you can configure and run it without reading the entire repo first.

## Demo Index

### Secrets Manager demos

- [`sm-plugin-jwt`](./sm-plugin-jwt.md): GitHub OIDC JWT with `cyberark/conjur-action` for Secrets Manager.
- [`sm-plugin-jwt-env-aware`](./sm-plugin-jwt-env-aware.md): branch-driven GitHub environment selection with the JWT plugin flow.
- [`sm-direct-jwt`](./sm-direct-jwt.md): direct Secrets Manager API authentication and secret retrieval using raw `curl`.
- [`sm-plugin-apikey`](./sm-plugin-apikey.md): Secrets Manager host ID and API key with `cyberark/conjur-action`.
- [`sm-plugin-jwt-terraform`](./sm-plugin-jwt-terraform.md): GitHub OIDC to Secrets Manager, then Terraform provider execution using runtime-fetched credentials.

### TruffleHog demos

- [`trufflehog-single-scan`](./trufflehog-single-scan.md): single public repository scan with artifact and summary output.
- [`trufflehog-multi-scan`](./trufflehog-multi-scan.md): multi-repository scan driven by `TRUFFLEHOG_REPOS`.

## Workflow Files

- [`.github/workflows/sm-plugin-jwt.yml`](./.github/workflows/sm-plugin-jwt.yml)
- [`.github/workflows/sm-plugin-jwt-env-aware.yml`](./.github/workflows/sm-plugin-jwt-env-aware.yml)
- [`.github/workflows/sm-direct-jwt.yml`](./.github/workflows/sm-direct-jwt.yml)
- [`.github/workflows/sm-plugin-apikey.yml`](./.github/workflows/sm-plugin-apikey.yml)
- [`.github/workflows/sm-plugin-jwt-terraform-apikey.yml`](./.github/workflows/sm-plugin-jwt-terraform-apikey.yml)
- [`.github/workflows/trufflehog-single-scan.yml`](./.github/workflows/trufflehog-single-scan.yml)
- [`.github/workflows/trufflehog-multi-scan.yml`](./.github/workflows/trufflehog-multi-scan.yml)

## Supporting Files

The Terraform-backed demo also uses:

- [`main.tf`](./main.tf)
- [`providers.tf`](./providers.tf)

GitHub setup reference:

- [`github_setup.md`](./github_setup.md)
- [`scripts/README.md`](./scripts/README.md)

## GitHub CLI Setup

Create all GitHub environments used by this repo:

```bash
gh api --method PUT repos/OWNER/REPO/environments/dev
gh api --method PUT repos/OWNER/REPO/environments/staging
gh api --method PUT repos/OWNER/REPO/environments/main
gh api --method PUT repos/OWNER/REPO/environments/terraform
```

Initialize repository variables, repository secrets, and all supported environments with the helper script:

```bash
SM_URL='https://example.secretsmgr.example' \
SM_ACCOUNT='my-account' \
SM_JWT_AUTHN_ID='github' \
SM_SECRET_ID_1='path/to/secret-1' \
SM_SECRET_ID_2='path/to/secret-2' \
SM_USERNAME='host/my-app' \
SM_API_KEY='super-secret' \
DEV__SM_URL='https://dev.example.secretsmgr.example' \
DEV__SM_ACCOUNT='my-account' \
DEV__SM_JWT_AUTHN_ID='github-dev' \
DEV__SM_SECRET_ID_1='path/to/dev-secret-1' \
DEV__SM_SECRET_ID_2='path/to/dev-secret-2' \
STAGING__SM_URL='https://staging.example.secretsmgr.example' \
STAGING__SM_ACCOUNT='my-account' \
STAGING__SM_JWT_AUTHN_ID='github-staging' \
STAGING__SM_SECRET_ID_1='path/to/staging-secret-1' \
STAGING__SM_SECRET_ID_2='path/to/staging-secret-2' \
MAIN__SM_URL='https://prod.example.secretsmgr.example' \
MAIN__SM_ACCOUNT='my-account' \
MAIN__SM_JWT_AUTHN_ID='github-main' \
MAIN__SM_SECRET_ID_1='path/to/prod-secret-1' \
MAIN__SM_SECRET_ID_2='path/to/prod-secret-2' \
TERRAFORM__SM_URL='https://terraform.example.secretsmgr.example' \
TERRAFORM__SM_ACCOUNT='my-account' \
TERRAFORM__SM_JWT_AUTHN_ID='github-terraform' \
TERRAFORM__SM_SECRET_ID_1='path/to/bootstrap-secret' \
TERRAFORM__SM_SECRET_ID_2='path/to/api-key-secret' \
TERRAFORM__TFVAR_APPLIANCE_URL='https://conjur.example' \
TERRAFORM__TFVAR_ACCOUNT='my-account' \
TERRAFORM__TFVAR_LOGIN='host/terraform' \
TERRAFORM__TFVAR_SSL_CERT='-----BEGIN CERTIFICATE-----...' \
TERRAFORM__TFVAR_sm_secret_id_1='path/to/aws-creds' \
TERRAFORM__TFVAR_API_KEY='bootstrap-api-key' \
bash scripts/init-gh-vars-secrets.sh --env dev --env staging --env main --env terraform --non-interactive
```

## Usage

1. Pick a demo from the list above.
2. Open the matching Markdown file for required GitHub variables, secrets, and validation steps.
3. Run the corresponding workflow with `workflow_dispatch`.

## Notes

- The Secrets Manager demos assume a reachable service instance and pre-created policy, identities, and variables.
- The TruffleHog demos assume Docker execution on GitHub-hosted runners and focus on public repositories.
