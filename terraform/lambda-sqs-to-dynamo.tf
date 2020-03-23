resource "aws_lambda_function" "lambda_sqs_to_dynamo_function" {
  filename = "../node/lambda.zip"
  function_name = "LambdaPublishToDynamo"
  handler = "index.dynamodbHandler"
  role = aws_iam_role.lambda_sqs_to_dynamo_execution_role.arn
  runtime = "nodejs12.x"
}

resource "aws_lambda_event_source_mapping" "sqs_source" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name = aws_lambda_function.lambda_sqs_to_dynamo_function.arn
}

resource "aws_iam_role" "lambda_sqs_to_dynamo_execution_role" {
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "sqs_to_dynamo_sqs_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role = aws_iam_role.lambda_sqs_to_dynamo_execution_role.name
}

resource "aws_iam_role_policy_attachment" "sqs_to_dynamo_dynamodb_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role = aws_iam_role.lambda_sqs_to_dynamo_execution_role.name
}

resource "aws_iam_role_policy_attachment" "sqs_to_dynamo_cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_sqs_to_dynamo_execution_role.name
}