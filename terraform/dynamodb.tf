resource "aws_dynamodb_table" "dynamodb_table"{
  hash_key = "id"
  name = "MessagesTable"
  write_capacity = 5
  read_capacity = 5

  attribute {
    name = "id"
    type = "S"
  }
}