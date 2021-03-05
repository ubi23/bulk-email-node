data "template_file" "task_definition_app" {
  template = file("${path.module}/config/task-definition.json.tmpl")
  vars = {
    name = local.container_name
    port = var.container_port
  }
}

resource "aws_ecs_task_definition" "task_definition_app" {
  family                   = var.tags.ServiceName
  container_definitions    = data.template_file.task_definition_app.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  tags                     = var.tags
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
}

# Role that the Amazon ECS container agent and the Docker daemon can assume.
resource "aws_iam_role" "task_execution_role" {
  name               = "${var.tags.Service}-ECSTaskDefinition"
  description        = "Role used by the ECS to execute the tasks and access other AWS services"
  assume_role_policy = data.aws_iam_policy_document.assume_task_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role  = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.ECSTaskDefinitionPolicy.arn
}

# Role that allows your Amazon ECS container task to make calls to other AWS services.
resource "aws_iam_role" "task_role" {
  name               = "${var.tags.Service}-TaskRole"
  description        = "Role used by the ECS tasks to access other AWS services"
  assume_role_policy = data.aws_iam_policy_document.assume_task_role.json
  tags               = var.tags
}


data "aws_iam_policy_document" "assume_task_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ECSTaskDefinitionPolicy" {
  name   = "${var.tags.Service}-ECSTaskDefinition"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "cloudwatch:*"
      ],
      "Effect": "Allow",
      "Resource": [ "*" ]
    },
    {
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Effect": "Allow",
      "Resource": [ "${aws_secretsmanager_secret.sendgrid_api_key.arn}" ]
    }
  ]
}
EOF
}
