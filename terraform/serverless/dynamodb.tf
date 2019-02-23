resource "aws_dynamodb_table" "ideation-aws-dynamodb-table" {

  name = "IdeationAWS"

  read_capacity = 5
  write_capacity = 5
  
  hash_key = "Id"
  range_key = "Name"

  attribute = [
    {
      name = "Id"
      type = "S"
    },
    {
      name = "Name"
      type = "S"
    }
  ]
}

