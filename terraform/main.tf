## Specify the provider and access details
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.aws_region}"
}


## Specify default security group to access the instances over SSH and HTTP
resource "aws_security_group" "default" {
    name = "Terraform-example"
    description = "Security Group for Terraform"

    # SSH access from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    # HTTP access from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "web" {
    name = "Terraform-example-elb"

    # The same availability zone as our instance
    availability_zones = ["${aws_instance.web.availability_zone}"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
  
    # The instance is registered automatically
    instances = ["${aws_instance.web.id}"]
}

resource "aws_instance" "web" {
    # The connection block tells our provisioner how to communicate with the resource (instance)
    connection {
        # The default username for AMI instance
        user = "ec2-user"

        # The path to your keyfile
        key_file = "${var.key_path}"
    }

    instance_type = "t2.micro"

    tags {
        Name = "terraform-example"
    }

    # Lookup the correct AMI based on the region specified
    ami = "${lookup(var.aws_amis, var.aws_region)}"

    # The name of our SSH keypair created and downloaded from the AWS console, e.g.:
    #
    #   https://ap-southeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#KeyPairs:sort=keyName
    #
    key_name = "${var.key_name}"

    # Security group to allow HTTP and SSH access
    security_groups = ["${aws_security_group.default.name}"]

    # Run a remote provisioner on the instance after creating it
    provisioner "file" {
        source = "../images/"
        destination = "/tmp/"
    }	

    provisioner "remote-exec" {
        inline = [
            "pwd",
            "ls -al"        
        ]
    }
}
