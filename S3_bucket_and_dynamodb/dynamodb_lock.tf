resource "aws_dynamodb_table" "Prefect_dynamoDb_lock" {
  name           = "Prefect_dynamoDb_lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Prefect_dynamoDb_lock"
  }
}
