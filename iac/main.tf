#################################################
# Main Definitions and Settings
#################################################

terraform {
  backend "s3" {
    encrypt = true
    region  = "us-east-1"
    bucket  = "gio-infrastructure"
    key     = "sites/my-great.app/terraform.tfstate"
  }
}

# Certificates are ALWAYS from "us-east-1"
provider "aws" {
  alias  = "cert_provider"
  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
}

module "lambda_api" {
  source = "git::https://github.com/endaft/terraform-aws-lambda-api.git?ref=main"

  anonymous          = var.anonymous
  app_domain         = var.app_domain
  app_name           = var.app_name
  cognito_css_path   = var.cognito_css_path
  cognito_logo_path  = var.cognito_logo_path
  env                = var.env
  identity_providers = var.identity_providers
  lambda_configs     = var.lambda_configs
  local_dev_endpoint = var.local_dev_endpoint
  log_retention_days = var.log_retention_days
  password_rules     = var.password_rules
  request_params     = var.request_params
  tags               = var.tags
  token_map          = local.token_map
  token_validity     = var.token_validity
  web_apps           = var.web_apps
}
