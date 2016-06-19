## Elastic Load Balancer for Docker app i.e. "Hello World" listens on port 80 and and "Camel Spring" on 8080
resource "aws_elb" "ecs_elb" {
    name = "terraform-ecs-elb"
    availability_zones = ["${split(",", var.availability_zones)}"]
    security_groups = ["${aws_security_group.ecs_elb_sg.id}"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    listener {
        instance_port = 8080
        instance_protocol = "http"
        lb_port = 8080
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }

    connection_draining = false

    tags {
        Name = "terraform-ecs-elb"
    }
}

## Elastic Load Balancer for Docker app e.g. "Camel Spring" listens on port 8080
## Each ECS service should on an individual load balancer
#resource "aws_elb" "camel_spring_elb" {
#    name = "camel-spring-elb"
#    availability_zones = ["${split(",", var.availability_zones)}"]
#    security_groups = ["${aws_security_group.ecs_elb_sg.id}"]

#    listener {
#        instance_port = 8080
#        instance_protocol = "http"
#        lb_port = 8080
#        lb_protocol = "http"
#    }

#    health_check {
#        healthy_threshold = 2
#        unhealthy_threshold = 2
#        timeout = 3
#        target = "HTTP:8080/"
#        interval = 30
#    }

#    connection_draining = false

#    tags {
#        Name = "camel-spring-elb"
#    }
#}


## The launch configuration for each EC2 Instance that will run in the ECS Cluster
resource "aws_launch_configuration" "ecs_launch_configuration" {
    name_prefix = "terraform-ecs-launch-configuration-"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.name}"
    security_groups = ["${aws_security_group.ecs_instance_sg.id}"]
    image_id = "${lookup(var.aws_amis, var.aws_region)}"

    # A shell script that will execute when on each EC2 instance when it first boots to configure the ECS Agent to talk
    # to the right ECS cluster
    user_data = "${file("userdata/setup.bash")}"

    # Important note: whenever using a launch configuration with an auto scaling
    # group, you must set create_before_destroy = true. However, as soon as you
    # set create_before_destroy = true in one resource, you must also set it in
    # every resource that it depends on, or you'll get an error about cyclic
    # dependencies (especially when removing resources). For more info, see:
    #
    # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
    # https://terraform.io/docs/configuration/resources.html
    lifecycle {
        create_before_destroy = true
    }
}

## The Auto Scaling Group that determines how many EC2 Instances we will be running
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
    name = "terraform-ecs-autoscaling-group"
    min_size = 1
    max_size = 1
    launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.name}"
    vpc_zone_identifier = ["${split(",", var.ecs_cluster_subnet_ids)}"]

    load_balancers = ["${split(",", aws_elb.ecs_elb.name)}"]

    tag {
        key = "ecs-autoscaling-group"
        value = "terraform-ecs-autoscaling-group"
        propagate_at_launch = true
    }
}