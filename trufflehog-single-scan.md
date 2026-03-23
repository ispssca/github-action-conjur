# `trufflehog-single-scan` Demo

## Overview

This demo runs a simple TruffleHog scan against a known public test repository and publishes the raw JSON report as a workflow artifact plus a basic job summary.

The workflow file is [`.github/workflows/trufflehog-single-scan.yml`](./.github/workflows/trufflehog-single-scan.yml).

## What This Demo Proves

- A GitHub-hosted runner can execute TruffleHog in Docker.
- TruffleHog NDJSON output can be captured and summarized with `jq`.
- The job can preserve results even when TruffleHog exits non-zero.

## Target Repository

The workflow scans:

- `https://github.com/trufflesecurity/test_keys`

This repository is intentionally useful for secret-scanning demonstrations.

## Workflow Behavior

1. Creates a local `reports` directory.
2. Runs `trufflesecurity/trufflehog:latest` in Docker against the target repository.
3. Uses `--json` and `--only-verified` to limit output to verified findings.
4. Saves the result to `reports/trufflehog-report.json`.
5. Stores the TruffleHog exit code in workflow outputs instead of failing the job.
6. Uploads the JSON report as the `trufflehog-report` artifact.
7. Uses `jq` to summarize the first 25 events in `GITHUB_STEP_SUMMARY`.

## How To Run

1. Open the Actions tab.
2. Select `TruffleHog-Simple-Scan`.
3. Run the workflow manually.

## Validation

- The workflow completes even if TruffleHog returns a non-zero exit code.
- The artifact `trufflehog-report` contains `reports/trufflehog-report.json`.
- The job summary shows the target repository, exit code, and total event count.

## Troubleshooting

- If Docker execution fails, confirm GitHub-hosted runners still allow the TruffleHog container image to run normally.
- If `jq` parsing fails, verify the report file contains NDJSON rather than an empty file.
- If there are no findings, confirm the public target repository has not changed significantly.
