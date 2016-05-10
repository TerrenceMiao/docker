variable "key_name" {
    description = "Name of the SSH keypair to use in AWS"
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified"
}

variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {
    description = "AWS region to launch servers"
    default = "ap-southeast-2"
}

## Amazon Linux AMI 2016.03.1 (HVM), SSD Volume Type
variable "aws_amis" {
    default = {
        ap-southeast-2 = "ami-0c95b86f"
    }
}
