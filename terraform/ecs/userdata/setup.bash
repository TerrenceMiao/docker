#!/bin/bash

# Install the ecs-init package
yum install -y ecs-init

# Add AWS instance into Auto Scaling cluster
echo "ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name}" > /etc/ecs/ecs.config

# Start the Docker daemon
service docker start

# Start the ecs-init upstart job
start ecs

# Add ec2-user to the docker group
usermod -a -G docker ec2-user
