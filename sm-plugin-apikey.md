# `sm-plugin-apikey` Demo

## Overview

This demo uses the CyberArk GitHub Action with a Secrets Manager host identity and API key instead of GitHub OIDC. It demonstrates the plugin path for CI/CD systems that authenticate with a long-lived machine identity. Note: Secrets Manager was previously called Conjur.

The workflow file is [`.github/workflows/sm-plugin-apikey.yml`](./.github/workflows/sm-plugin-apikey.yml).

## What This Demo Proves

- The CyberArk GitHub Action can authenticate with `host_id` and `api_key`.
- Secrets Manager variables can be injected into workflow environment variables without OIDC.
- Retrieved values can be consumed by later steps and captured as artifacts.

## Required GitHub Configuration

Repository or environment variables:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

Repository or environment secrets:

- `SM_USERNAME`
- `SM_API_KEY`

## Workflow Behavior

1. Calls `cyberark/conjur-action@v2.0.5`.
2. Authenticates with `host_id: ${{ secrets.SM_USERNAME }}` and `api_key: ${{ secrets.SM_API_KEY }}`.
3. Maps the requested Secrets Manager variables to `SSH_USERNAME` and `SSH_PASSWORD`.
4. Prints masked values to the logs.
5. Writes all debug context to `/tmp/env.txt`.
6. Uploads `env.txt` as a workflow artifact.

## How To Run

1. Populate the required GitHub variables and secrets.
2. Open the Actions tab.
3. Run `sm-apikey-plugin`.

## Validation

- The Secrets Manager action step completes successfully.
- `SSH_USERNAME` and `SSH_PASSWORD` are masked in the logs.
- The `env.txt` artifact is uploaded.

## Troubleshooting

- If authentication fails, verify `SM_USERNAME` is the Secrets Manager host identity expected by policy.
- If the API key is stale, rotate it and update `SM_API_KEY`.
- If variables resolve but the action still fails, verify the host has `read` permission on both secret IDs.
- This workflow still requests `id-token: write`, but it does not use GitHub OIDC. That permission can be removed if you want the minimal API key example.
