# `sm-direct-jwt` Demo

## Overview

This demo shows direct Secrets Manager API usage from GitHub Actions. Instead of using the CyberArk GitHub Action, the workflow retrieves a GitHub OIDC JWT, exchanges it for a session token, and fetches secrets with raw `curl` calls. Note: Secrets Manager was previously called Conjur.

The workflow file is [`.github/workflows/sm-direct-jwt.yml`](./.github/workflows/sm-direct-jwt.yml).

## What This Demo Proves

- GitHub Actions can authenticate to Secrets Manager with OIDC JWT directly.
- Secrets Manager session tokens can be obtained without the helper action.
- Secrets can be retrieved through the Secrets Manager REST API and written into the workflow environment.

## Required GitHub Configuration

Repository or environment variables:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

The job must keep:

- `permissions.id-token: write`
- `permissions.contents: read`

## Workflow Behavior

1. Builds `CONJUR_AUTHENTICATE_URL` and `CONJUR_RETRIEVE_URL` from GitHub variables.
2. Requests a GitHub OIDC ID token.
3. Writes the JWT to `GITHUB_ENV` and uploads it as `actions.jwt`.
4. Posts the JWT to the Secrets Manager `authn-jwt` authenticate endpoint.
5. Uses the returned session token to fetch two Secrets Manager variables from the REST API.
6. Stores the results as `SECRET_1` and `SECRET_2`.
7. Writes a debug snapshot to `/tmp/output.txt` and uploads it.

## How To Run

1. Open the GitHub Actions tab.
2. Select `sm-direct-jwt`.
3. Run the workflow manually.

## Validation

- `Authenticate to Secrets Manager`, `Fetch secret 1`, and `Fetch secret 2` all succeed.
- The logs show the expected Secrets Manager authenticate and retrieve URLs.
- `SECRET_1` and `SECRET_2` are present in the later steps.
- The `actions.jwt` and `output.txt` artifacts are uploaded.

## Troubleshooting

- If the Secrets Manager authenticate call fails, verify the JWT authenticator policy and the GitHub claim mapping.
- If the retrieve call fails, verify the authenticated identity is allowed to read both variables.
- The workflow uses `curl -k`, so TLS verification is skipped. If that is not intended, replace it with proper certificate validation.
- If `jq` parsing fails during JWT retrieval, verify the runner still returns the OIDC response in the expected JSON format.
