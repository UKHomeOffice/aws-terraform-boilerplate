resource "aws_dynamodb_table" "parts" {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Key"
  name         = "${var.environment}-Parts"

  attribute {
    name = "GroupRef"
    type = "S"
  }
  attribute {
    name = "Key"
    type = "S"
  }
  attribute {
    name = "SearchRef"
    type = "S"
  }
  attribute {
    name = "Status"
    type = "S"
  }

  global_secondary_index {
    hash_key        = "GroupRef"
    name            = "GroupRef-index"
    projection_type = "ALL"
  }
  global_secondary_index {
    hash_key        = "SearchRef"
    name            = "SearchRef-index"
    projection_type = "ALL"
  }
  global_secondary_index {
    hash_key        = "Status"
    name            = "Status-index"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }
}
