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

variable "vpc_id" {
  	description = "The id of the VPC where the ECS cluster should run"
  	# Set vpc_id to the id of the "Default" VPC from the VPC list: 
	#	https://ap-southeast-2.console.aws.amazon.com/vpc/home?region=ap-southeast-2#vpcs:
	default = {
		vpc_id = "vpc-8c3554e9"
	}
}

variable "ecs_cluster_subnet_ids" {
  	description = "A comma-separated list of subnets where the EC2 instances for the ECS cluster should be deployed"
  	# Set both subnet_ids lists to the subnet ids (separated with commas) from the subnet list: 
	#	https://ap-southeast-2.console.aws.amazon.com/vpc/home?region=ap-southeast-2#subnets:
	default = {
		ecs_cluster_subnet_ids = "subnet-e51b5080,subnet-02732244,subnet-96bccde1"
	}
}