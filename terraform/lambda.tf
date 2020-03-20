/*resource "aws_lambda_function" "lambda_function" {
  filename = "../node/lambda_function.zip"
  function_name = "LambdaPublishToDynamo"
  handler = "exports.lambda"
  role = aws_iam_role.lambda_execution_role.arn
  runtime = "nodejs12.x"
}*/

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "sqs_policy" {
  name = "SQSPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_sqs_permissions_to_execution_role" {
  policy_arn = aws_iam_policy.sqs_policy.arn
  role = aws_iam_role.lambda_execution_role.name
}