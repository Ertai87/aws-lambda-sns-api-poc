resource "aws_lambda_function" "lambda_apigateway_to_sns_function" {
  filename = "../node/lambda.zip"
  function_name = "LambdaPublishToSns"
  handler = "index.snsHandler"
  role = aws_iam_role.lambda_apigateway_to_sns_execution_role.arn
  runtime = "nodejs12.x"
}

resource "aws_iam_role" "lambda_apigateway_to_sns_execution_role" {
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

resource "aws_iam_role_policy_attachment" "apigateway_to_sns_sns_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  role = aws_iam_role.lambda_apigateway_to_sns_execution_role.name
}

resource "aws_iam_role_policy_attachment" "apigateway_to_sns_cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_apigateway_to_sns_execution_role.name
}