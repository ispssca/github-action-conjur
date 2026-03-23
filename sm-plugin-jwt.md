# `sm-plugin-jwt` Demo

## Overview

This demo shows GitHub Actions authenticating to Secrets Manager with a GitHub OIDC JWT and retrieving secrets through the `cyberark/conjur-action` plugin. Note: Secrets Manager was previously called Conjur.

The workflow file is [`.github/workflows/sm-plugin-jwt.yml`](./.github/workflows/sm-plugin-jwt.yml).

## What This Demo Proves

- GitHub Actions can request an OIDC ID token at runtime.
- Secrets Manager can trust that JWT through a configured `authn-jwt` authenticator.
- The CyberArk GitHub Action can map Secrets Manager variables into masked workflow environment variables.

## Prerequisites

- A GitHub repository with Actions enabled.
- A Secrets Manager environment reachable from GitHub-hosted runners.
- A configured Secrets Manager `authn-jwt` authenticator for GitHub Actions.
- Two Secrets Manager variables that can be retrieved by the GitHub workload identity.

## Required GitHub Configuration

Repository or environment variables:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

The workflow uses `id-token: write` and `contents: read` permissions. No API key is required in this demo.

## Workflow Behavior

1. Prints the configured Secrets Manager variables for basic debugging.
2. Uses `actions/github-script@v6` to expose the GitHub Actions OIDC request token and request URL.
3. Calls the OIDC endpoint with `curl` and writes the returned JWT to `GITHUB_ENV` as `JWT`.
4. Uploads the raw JWT as the `actions.jwt` artifact.
5. Runs `cyberark/conjur-action@v2.0.5` with `authn_id` set to the JWT authenticator ID.
6. Maps two Secrets Manager variables to `SECRET_1` and `SECRET_2`.
7. Writes a debug file to `/tmp/output.txt` and uploads it as an artifact.

## How To Run

1. Open the GitHub Actions tab.
2. Select `sm-plugin-jwt`.
3. Run the workflow with `workflow_dispatch`.

## Validation

After the run completes, confirm the following:

- The `Get JWT` step completes successfully.
- The `Import secrets with plugin` step succeeds.
- The `Show imported environment variable names` step confirms both environment variables are present.
- The workflow artifacts include `actions.jwt` and `output.txt`.

## Troubleshooting

- If JWT retrieval fails, verify the job still has `permissions.id-token: write`.
- If the Secrets Manager action fails, verify `SM_URL`, `SM_ACCOUNT`, and `SM_JWT_AUTHN_ID`.
- If the secret lookup fails, verify the workload identity is entitled to both variable IDs.
- If the repository uses GitHub environments, confirm the selected environment exposes the needed variables.
