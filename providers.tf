terraform {
  required_providers {
    conjur = {
      source  = "cyberark/conjur"
      version = "0.6.3"
    }
  }
}

provider "conjur" {
  appliance_url = var.appliance_url
  account = var.account
  login = var.login
  api_key = var.api_key
  #ssl_cert_path = var.ssl_cert_path
  #ssl_cert = var.ssl_cert
}

data "conjur_secret" "secret_1" {
  name = var.conjur_secret_id_1
}

locals {
  aws_creds_json = jsondecode(data.conjur_secret.secret_1.value)
}

//noinspection HILUnresolvedReference
provider "aws" {
  region     = var.aws_region
  access_key = local.aws_creds_json["data"]["access_key_id"]
  secret_key = local.aws_creds_json["data"]["secret_access_key"]
  token = local.aws_creds_json["data"]["session_token"]
}
