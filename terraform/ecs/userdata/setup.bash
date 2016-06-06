#!/bin/bash

# Install the ecs-init package
yum install -y ecs-init

# Add AWS instance into Auto Scaling cluster
# ECS_CLUSTER should be as SAME as ${aws_ecs_cluster.ecs_cluster.name}" in configuration 
echo "ECS_CLUSTER=terraform-ecs-cluster" > /etc/ecs/ecs.config

# Start the Docker daemon
service docker start

# Start the ecs-init upstart job
start ecs

# Add ec2-user to the docker group
usermod -a -G docker ec2-user

# Install and run Weave Scope
wget -O /usr/local/bin/scope https://git.io/scope
chmod a+x /usr/local/bin/scope
/usr/local/bin/scope launch
