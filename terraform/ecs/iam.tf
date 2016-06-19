## An IAM role that we attach to the EC2 Instances in ECS
resource "aws_iam_role" "ecs_instance_role" {
    name = "terraform-ecs-instance-role"
    assume_role_policy = "${file("policies/ecs-instance-role.json")}"

    # aws_iam_instance_profile.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
    # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
    lifecycle {
        create_before_destroy = true
    }
}

## IAM policy we add to our EC2 Instance Role that allows an ECS Agent running
## on the EC2 Instance to communicate with the ECS cluster
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
    name = "terraform-ecs-instance-role-policy"
    role = "${aws_iam_role.ecs_instance_role.id}"
    policy = "${file("policies/ecs-instance-role-policy.json")}"
}


## An IAM Role that we attach to ECS Services. See the
## aws_aim_role_policy below to see what permissions this role has
resource "aws_iam_role" "ecs_service_role" {
    name = "terraform-ecs-service-role"
    assume_role_policy = "${file("policies/ecs-service-role.json")}"
}

## IAM Policy that allows an ECS Service to communicate with EC2 Instances.
resource "aws_iam_role_policy" "ecs_service_policy" {
    name = "terraform-ecs-service-policy"
    role = "${aws_iam_role.ecs_service_role.id}"
    policy = "${file("policies/ecs-service-role-policy.json")}"
}


## An IAM instance profile we can attach to an EC2 instance
resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "terraform-ecs-instance-profile"
    roles = ["${aws_iam_role.ecs_instance_role.name}"]

    # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
    # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
    lifecycle {
        create_before_destroy = true
    }
}
