## The ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
    # This name MUST match ECS_CLUSTER set in /etc/ecs/ecs.config file on AWS instance
    name = "terraform-ecs-cluster"

    # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
    # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
	family = "hello-world-task"
	container_definitions = "${file("task-definitions/hello-world-task.json")}"
}

## ECS service and task definitions for running container
resource "aws_ecs_service" "ecs-service" {
	name = "terraform-ecs-service"
  	cluster = "${aws_ecs_cluster.ecs_cluster.id}"
  	task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
  	desired_count = 1
  	iam_role = "${aws_iam_role.ecs_service_role.arn}"
  	depends_on = ["aws_iam_role_policy.ecs_service_policy"]

  	load_balancer {
    	elb_name = "${aws_elb.ecs_elb.id}"
    	container_name = "hello-world-container"
    	container_port = 5000
  	}
}
