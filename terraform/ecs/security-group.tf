## Security group that controls what network traffic is allowed to go in and out of each EC2 instance in the cluster
resource "aws_security_group" "ecs_instance_sg" {
    name = "terraform-ecs-instance-sg"
    description = "Security group for the EC2 instances in the ECS cluster"
    vpc_id = "${var.vpc_id}"

    # Outbound Everything
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound HTTP for the frontend from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound HTTP for the backend from anywhere
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound SSH from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
    # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
    lifecycle {
        create_before_destroy = true
    }
}