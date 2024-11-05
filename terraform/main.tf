provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  network_mode             = "bridge"
  
  container_definitions = <<DEFINITION
[
  {
    "name": "my-app",
    "image": "${var.docker_image}",
    "memory": 512,
    "cpu": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.id
  desired_count   = 1

  network_configuration {
    subnets          = ["your_subnet_id"]
    security_groups  = ["your_security_group_id"]
    assign_public_ip = true
  }
}

