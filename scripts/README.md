# Scripts

## `init-gh-vars-secrets.sh`

Initializes GitHub repository variables and secrets with the `gh` CLI, but only when they do not already exist.

It can also create and seed the optional GitHub environments used by this repo:

- `dev`
- `staging`
- `main`
- `terraform`

Examples:

```bash
scripts/init-gh-vars-secrets.sh
```

```bash
SM_URL='https://example.secretsmgr.example' \
SM_ACCOUNT='my-account' \
SM_JWT_AUTHN_ID='github' \
SM_SECRET_ID_1='path/to/secret-1' \
SM_SECRET_ID_2='path/to/secret-2' \
SM_USERNAME='host/my-app' \
SM_API_KEY='super-secret' \
scripts/init-gh-vars-secrets.sh --non-interactive
```

```bash
DEV__SM_URL='https://dev.example.secretsmgr.example' \
TERRAFORM__TFVAR_APPLIANCE_URL='https://conjur.example' \
TERRAFORM__TFVAR_ACCOUNT='my-account' \
TERRAFORM__TFVAR_LOGIN='host/terraform' \
TERRAFORM__TFVAR_SSL_CERT='-----BEGIN CERTIFICATE-----...' \
TERRAFORM__TFVAR_sm_secret_id_1='path/to/aws-creds' \
TERRAFORM__TFVAR_API_KEY='bootstrap-api-key' \
scripts/init-gh-vars-secrets.sh --env dev --env terraform --non-interactive
```
