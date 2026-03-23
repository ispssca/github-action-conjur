# `sm-plugin-jwt-terraform` Demo

## Overview

This demo combines GitHub OIDC, direct Secrets Manager API authentication, and Terraform. GitHub Actions retrieves a JWT, uses it to obtain secrets, injects one of those secrets into Terraform as `TF_VAR_api_key`, and then applies the Terraform configuration in this repository. Note: Secrets Manager was previously called Conjur.

The workflow file is [`.github/workflows/sm-plugin-jwt-terraform-apikey.yml`](./.github/workflows/sm-plugin-jwt-terraform-apikey.yml).

## What This Demo Proves

- GitHub OIDC can authenticate to Secrets Manager at workflow runtime.
- Secrets Manager can supply Terraform provider credentials on demand.
- Terraform can use a runtime-fetched secret to configure the `cyberark/conjur` provider and an AWS provider.

## Repository Files Used By This Demo

- [`main.tf`](./main.tf)
- [`providers.tf`](./providers.tf)

The Terraform configuration:

- Configures the `cyberark/conjur` provider.
- Reads one Secrets Manager variable with `data "conjur_secret"`.
- Decodes that secret as AWS credentials JSON.
- Configures the AWS provider from the decoded values.
- Outputs the Secrets Manager secret and selected AWS credential fields as sensitive outputs.

## Required GitHub Configuration

Repository or environment variables:

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

Repository or environment secrets:

- `TFVAR_API_KEY`

## Workflow Behavior

1. Exposes `TF_VAR_*` environment variables for Terraform.
2. Retrieves a GitHub OIDC JWT and uploads it as `actions.jwt`.
3. Authenticates directly to Secrets Manager with that JWT.
4. Retrieves two Secrets Manager variables with `curl`.
5. Replaces `TF_VAR_api_key` in the workflow environment with the secret fetched from Secrets Manager.
6. Checks out the repository.
7. Installs Terraform `1.10.0`.
8. Runs `terraform init`.
9. Runs `terraform apply -auto-approve -input=false`.
10. Prints selected Terraform outputs.

## How To Run

1. Populate the GitHub variables and secrets listed above.
2. Ensure the secret referenced by `SM_SECRET_ID_1` contains JSON with `access_key_id`, `secret_access_key`, and `session_token`.
3. Run `sm-plugin-jwt-terraform` from the Actions tab.

## Validation

- `Authenticate to Secrets Manager`, `Fetch provider bootstrap secret`, and `Fetch Terraform API key secret` all succeed.
- `terraform init` installs the `cyberark/conjur` provider successfully.
- `terraform apply` completes without prompting.
- The final output step prints `secret_1_output`, `aws_key`, and `aws_secret`.

## Troubleshooting

- If Terraform cannot authenticate to Secrets Manager, verify the fetched `TF_VAR_api_key` belongs to the `TFVAR_LOGIN` identity.
- If the AWS provider fails, verify the Secrets Manager secret contains valid AWS STS-style JSON fields.
- If TLS errors appear, inspect `TFVAR_SSL_CERT` and confirm it contains the expected PEM content.
- The workflow also defines `TFVAR_API_KEY` as a GitHub secret, but then overwrites `TF_VAR_api_key` from Secrets Manager. Treat the GitHub secret as bootstrap or remove it if it is no longer required.
