resource "aws_sqs_queue" "sqs_queue" {
  name = "MessageQueue"
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  endpoint = aws_sqs_queue.sqs_queue.arn
  protocol = "sqs"
  topic_arn = aws_sns_topic.sns_topic.arn
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.sqs_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}