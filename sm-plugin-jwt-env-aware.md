# `sm-plugin-jwt-env-aware` Demo

## Overview

This demo extends the JWT plugin flow by selecting the GitHub Actions environment from the current branch. It is intended to prove that the same workflow can resolve different Secrets Manager settings for `dev`, `staging`, and `main`. Note: Secrets Manager was previously called Conjur.

The workflow file is [`.github/workflows/sm-plugin-jwt-env-aware.yml`](./.github/workflows/sm-plugin-jwt-env-aware.yml).

## What This Demo Proves

- Branch-based environment selection works in GitHub Actions.
- Environment-scoped GitHub variables can drive Secrets Manager authentication and secret selection.
- The CyberArk plugin flow works without changing the workflow body for each environment.

## Branch To Environment Mapping

- `refs/heads/dev` -> `dev`
- `refs/heads/staging` -> `staging`
- `refs/heads/main` -> `main`
- Anything else -> `unknown`

If the branch resolves to `unknown`, environment-scoped variables will usually be missing and the demo should be treated as not configured.

## Required GitHub Configuration

Create GitHub environments named:

- `dev`
- `staging`
- `main`

For each environment, define:

- `SM_URL`
- `SM_ACCOUNT`
- `SM_JWT_AUTHN_ID`
- `SM_SECRET_ID_1`
- `SM_SECRET_ID_2`

## Workflow Behavior

1. Resolves the `environment.name` value from the current branch.
2. Prints the environment-scoped variables for debugging.
3. Requests a GitHub OIDC JWT.
4. Uploads the JWT as `actions.jwt`.
5. Uses `cyberark/conjur-action@v2.0.5` to fetch two Secrets Manager variables.
6. Writes the resolved values and environment dump to `/tmp/output.txt`.
7. Uploads `output.txt` as an artifact.

## How To Run

1. Push the workflow file to a branch named `dev`, `staging`, or `main`, or manually dispatch it from one of those refs.
2. Run `sm-plugin-jwt-env-aware`.
3. Inspect which GitHub environment was attached to the job.

## Validation

- The job shows the expected GitHub environment for the branch.
- The plugin step succeeds without changing the workflow YAML.
- `SECRET_1` and `SECRET_2` are populated and masked.
- The output artifact reflects the environment-specific Secrets Manager values.

## Troubleshooting

- If the wrong environment is selected, confirm the workflow ran from the expected ref.
- If values are blank, verify the GitHub environment actually defines the variables.
- If the environment is `unknown`, run from `dev`, `staging`, or `main`.
- If Secrets Manager authentication fails in one environment only, compare the environment-specific authenticator ID and variable paths.
