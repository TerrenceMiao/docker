resource "aws_lambda_function" "get-lambda" {

  function_name = "ideationAWS-get"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "${var.s3_node_bucket}"
  s3_key = "v${var.lambda_version}/getLambda.zip"

  # "main" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "index.handler"
  runtime = "nodejs8.10"
  memory_size = 128
  timeout = 30

  role = "${aws_iam_role.lambda-iam-role.arn}"
}

resource "aws_lambda_permission" "api-gateway-invoke-get-lambda" {

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get-lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_deployment.ideation-aws-api-gateway-deployment.execution_arn}/*/*"
}
