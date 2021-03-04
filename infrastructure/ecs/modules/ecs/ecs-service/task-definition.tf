data "template_file" "task_definition" {
  template = file("${path.module}/task-definition.json.tmpl")
  vars = {
    name = local.container_name
    port = var.container_port
  }
}

resource "aws_ecs_task_definition" "initial" {
  family                   = substr("${var.tags.Service}-task", 0, 255)
  container_definitions    = data.template_file.task_definition.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  tags                     = var.tags
  task_role_arn            = aws_iam_role.task_execution_role.arn

  lifecycle {
    ignore_changes = all
  }
}

# Create a role that the Task can use to access other AWS services
resource "aws_iam_role" "task_execution_role" {
  name               = "${var.tags.Service}-taskRole"
  description        = "Role used by the ECS tasks to access other AWS services"
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

