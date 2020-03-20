resource "aws_dynamodb_table" "dynamodb_table"{
  hash_key = "ID"
  name = "MessagesTable"
  write_capacity = 5
  read_capacity = 5

  attribute {
    name = "ID"
    type = "S"
  }
}