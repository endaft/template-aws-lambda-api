#################################################
# Config - Variable Manipulation for further use
#################################################

locals {
  env        = var.env
  app_slug   = lower(replace(var.app_name, "/[\\s\\W]+/", "-"))
  is_prod    = (local.env == "prod" || local.env == "production")
  env_prefix = (local.is_prod ? "" : "${var.env}-")
  roles = {
    billing_access = "${local.app_slug}-${local.env_prefix}lambda-billing"
  }
  data_table = {
    name     = "${local.app_slug}-${local.env_prefix}data"
    hash_key = "pk"
    sort_key = "sk"
  }
  token_map = {
    "$DATA_TABLE_NAME" = local.data_table.name
  }
  token_keys = keys(local.token_map)
}
