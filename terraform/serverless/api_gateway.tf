resource "aws_api_gateway_rest_api" "ideation-aws-api-gateway" {

  name        = "Ideation AWS API"
  description = "API to access Ideation AWS application"
  body        = "${data.template_file.ideation_aws_api_swagger.rendered}"
}

data "template_file" ideation_aws_api_swagger {

  template = "${file("swagger.yaml")}"

  vars {
    get_lambda_arn = "${aws_lambda_function.get-lambda.invoke_arn}"
    post_lambda_arn = "${aws_lambda_function.post-lambda.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "ideation-aws-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.ideation-aws-api-gateway.id}"
  stage_name  = "default"
}

output "url" {
  value = "${aws_api_gateway_deployment.ideation-aws-api-gateway-deployment.invoke_url}/api"
}
