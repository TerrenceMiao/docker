## The ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
    name = "terraform-ecs-cluster"

    # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
    # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
    lifecycle {
        create_before_destroy = true
    }
}
