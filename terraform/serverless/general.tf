provider "aws" {
  region = "ap-southeast-2"
}

## variables
variable "lambda_version" { default = "1.0.0"}
variable "s3_node_bucket" { default = "ideation-aws-node-bucket"}
variable "s3_data_bucket" { default = "ideation-aws-data-bucket"}
