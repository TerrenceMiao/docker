resource "aws_cloudwatch_event_rule" "ideation-aws-cloudwatch-event-rule" {
 
  name = "runLambdaEveryFiveMinute"
  
  depends_on = [
    "aws_lambda_function.async-lambda"
  ]

  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "ideation-aws-cloudwatch-event-target" {

  target_id = "async-lambda"

  rule = "${aws_cloudwatch_event_rule.ideation-aws-cloudwatch-event-rule.name}"
  
  arn = "${aws_lambda_function.async-lambda.arn}"
}