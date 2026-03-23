variable "appliance_url" {}
variable "account" {}
variable "login" {}
variable "api_key" {}
#variable "ssl_cert_path" {}
variable "ssl_cert" {}
variable "conjur_secret_id_1" {}

variable "aws_region" {
  type = string
  default = "ca-central-1"
}

data "aws_availability_zones" "available" {}

output "aws_availability_zones_output" {
  //noinspection HILUnresolvedReference
  value = data.aws_availability_zones.available
}

# data.conjur_secret.secret_1_output.value will be set by the Conjur Provider
output "secret_1_output" {
  //noinspection HILUnresolvedReference
  value = data.conjur_secret.secret_1.value
  # Must mark this output as sensitive for Terraform v0.15+,
  # because it's derived from a Conjur variable value that is declared as sensitive.
  sensitive = true
}

output "aws_key" {
  //noinspection HILUnresolvedReference
  value = local.aws_creds_json["data"]["access_key_id"]
  # Must mark this output as sensitive for Terraform v0.15+,
  # because it's derived from a Conjur variable value that is declared as sensitive.
  sensitive = true
}

output "aws_secret" {
  //noinspection HILUnresolvedReference
  value = local.aws_creds_json["data"]["secret_access_key"]
  # Must mark this output as sensitive for Terraform v0.15+,
  # because it's derived from a Conjur variable value that is declared as sensitive.
  sensitive = true
}

output "aws_token" {
  //noinspection HILUnresolvedReference
  value = local.aws_creds_json["data"]["session_token"]
  # Must mark this output as sensitive for Terraform v0.15+,
  # because it's derived from a Conjur variable value that is declared as sensitive.
  sensitive = true
}