# `trufflehog-multi-scan` Demo

## Overview

This demo scans multiple public repositories with TruffleHog. The repository list is supplied through a GitHub variable, and the workflow writes one NDJSON report per repository plus an aggregated summary.

The workflow file is [`.github/workflows/trufflehog-multi-scan.yml`](./.github/workflows/trufflehog-multi-scan.yml).

## What This Demo Proves

- GitHub Actions can scan a fleet of repositories from a single workflow run.
- TruffleHog output can be normalized into a stable artifact layout.
- A workflow can continue across per-repo failures and still produce a useful summary.

## Required GitHub Configuration

Repository or environment variable:

- `TRUFFLEHOG_REPOS`

Set it to a newline-separated list of public Git repository URLs. Blank lines and comment lines are ignored.

Example:

```text
https://github.com/trufflesecurity/test_keys
https://github.com/example-org/example-repo.git
```

## Workflow Behavior

1. Reads `vars.TRUFFLEHOG_REPOS`.
2. Removes blank lines and comment lines from the input list.
3. Converts each repository URL into an `owner__repo` slug.
4. Runs TruffleHog in Docker for each repository.
5. Writes one report file at `reports/<slug>/trufflehog.ndjson`.
6. Records per-repo exit code and event count in `reports/index.json`.
7. Uploads the entire `reports` tree as the `trufflehog-reports` artifact.
8. Writes a rich GitHub job summary with per-repo results, top findings, and detector breakdown.

## Output Layout

For each repository:

- `reports/<slug>/trufflehog.ndjson`

Aggregated output:

- `reports/index.json`

## How To Run

1. Define `TRUFFLEHOG_REPOS` in GitHub variables.
2. Open the Actions tab.
3. Select `trufflehog-multi-scan`.
4. Run the workflow manually.

## Validation

- The job summary shows the number of repositories scanned.
- The per-repo table lists exit code and event count for each repository.
- The `trufflehog-reports` artifact contains `index.json` and one folder per scanned repository.
- The detector breakdown section renders when findings exist.

## Troubleshooting

- If zero repositories are scanned, inspect `TRUFFLEHOG_REPOS` for blank content or comment-only lines.
- If one repository returns non-zero, the workflow still continues. Inspect that repository's `trufflehog.ndjson` for the actual failure text.
- The workflow normalizes some non-actionable TruffleHog errors such as "nothing to scan". If a repository still reports a failure, treat it as operational until the report proves otherwise.
- This demo assumes public repositories and does not inject any Git credentials.
