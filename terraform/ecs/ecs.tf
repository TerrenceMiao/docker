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

## Docker application "Hello World" ECS task and service definitions for running container
resource "aws_ecs_task_definition" "ecs_task_definition" {
	family = "hello-world-task"
	container_definitions = "${file("task-definitions/hello-world-task.json")}"
}

resource "aws_ecs_service" "ecs_service" {
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

## Docker application "Sumo Logic Collector" ECS task and service definitions for running container
resource "aws_ecs_task_definition" "sumo_logic_collector_task_definition" {
	family = "sumo-logic-collector-task"
	container_definitions = "${file("task-definitions/sumo-logic-collector-task.json")}"

	volume {
    	name = "sumo-logic-collector-volume"
    	host_path = "/tmp/clogs"
  	}
}

resource "aws_ecs_service" "sumo_logic_collector_service" {
	name = "sumo-logic-collector-service"
  	cluster = "${aws_ecs_cluster.ecs_cluster.id}"
  	task_definition = "${aws_ecs_task_definition.sumo_logic_collector_task_definition.arn}"
  	desired_count = 1
}