resource "aws_lambda_function" "async-lambda" {

  function_name = "ideationAWS-async"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "${var.s3_node_bucket}"
  s3_key = "v${var.lambda_version}/asyncLambda.zip"

  # "main" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "index.handler"
  runtime = "nodejs8.10"
  memory_size = 128
  timeout = 30

  role = "${aws_iam_role.lambda-iam-role.arn}"
}

resource "aws_lambda_permission" "cloud-watch-invoke-async-lambda" {

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.async-lambda.function_name}"
  principal     = "events.amazonaws.com"

  source_arn = "${aws_cloudwatch_event_rule.ideation-aws-cloudwatch-event-rule.arn}"
}