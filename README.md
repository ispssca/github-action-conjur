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

## Usage

1. Pick a demo from the list above.
2. Open the matching Markdown file for required GitHub variables, secrets, and validation steps.
3. Run the corresponding workflow with `workflow_dispatch`.

## Notes

- The Secrets Manager demos assume a reachable service instance and pre-created policy, identities, and variables.
- The TruffleHog demos assume Docker execution on GitHub-hosted runners and focus on public repositories.
