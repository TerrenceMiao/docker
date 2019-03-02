## ROLES - IAM role which dictates what other AWS services the Lambda function may access.

resource "aws_iam_role" "lambda-iam-role" {
  
  name = "ideation-aws-lambda-iam-role"

  assume_role_policy = <<EOF
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
EOF
}

## POLICIES
resource "aws_iam_role_policy" "dynamodb-lambda-policy"{

  name = "ideation-aws-dynamodb-lambda-policy"
  role = "${aws_iam_role.lambda-iam-role.id}"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.ideation-aws-dynamodb-table.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3-lambda-policy"{

  name = "ideation-aws-s3-lambda-policy"
  role = "${aws_iam_role.lambda-iam-role.id}"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": "${aws_s3_bucket.ideation-aws-s3-bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sqs-lambda-policy"{

  name = "ideation-aws-sqs-lambda-policy"
  role = "${aws_iam_role.lambda-iam-role.id}"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Resource": [
        "arn:aws:sqs:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invoke-lambda-policy"{

  name = "ideation-aws-invoke-lambda-policy"
  role = "${aws_iam_role.lambda-iam-role.id}"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": [
        "arn:aws:lambda:*:*:function:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch-lambda-policy"{
  
  name = "ideation-aws-cloudwatch-lambda-policy"
  role = "${aws_iam_role.lambda-iam-role.id}"
  
  policy = "${data.aws_iam_policy_document.api-gateway-logs-policy-document.json}"
}

data "aws_iam_policy_document" "api-gateway-logs-policy-document" {
  
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ],
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "sqs-consumer-policy" {

  count = "${length(var.queue_name)}"
  name  = "ideation-aws-sqs-consumer-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage*",
        "sqs:PurgeQueue",
        "sqs:ChangeMessageVisibility*"
      ],
      "Resource": [
        "${element(aws_sqs_queue.ideation-aws-queue.*.arn, count.index)}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "sqs-pusher-policy" {

  count = "${length(var.queue_name)}"
  name  = "ideation-aws-sqs-pusher-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:SendMessage*"
      ],
      "Resource": [
        "${element(aws_sqs_queue.ideation-aws-queue.*.arn, count.index)}"
      ]
    }
  ]
}
EOF
}