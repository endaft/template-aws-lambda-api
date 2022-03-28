#################################################
# AWS DynamoDb - Data Table Settings
#
# This could be any data source you like to use.
# See: iam.tf for permissions assignment
#################################################

resource "aws_dynamodb_table" "app_data" {
  name           = local.data_table.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = local.data_table.hash_key
  range_key      = local.data_table.sort_key

  attribute {
    name = local.data_table.hash_key
    type = "S"
  }

  attribute {
    name = local.data_table.sort_key
    type = "S"
  }
}
