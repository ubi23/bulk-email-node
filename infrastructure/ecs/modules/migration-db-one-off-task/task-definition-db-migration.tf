data "template_file" "task_definition_db_migration" {
  template = file("${path.module}/config/task-definition-db-migration.json.tmpl")
  vars = {
    NAME          = local.container_name
    COMMAND       = join("\",\"", [for s in var.task_definition_command : s])
    AWSLOGS_GROUP = var.ecs_log_group_name
    ENVIRONMENT   = "production" // var.tags.Environment
    IMAGE         = "232181100491.dkr.ecr.eu-west-2.amazonaws.com/fairfxgroup/${var.tags.Service}/${var.tags.Service}"
    IMAGE_TAG     = "latest"
    DB_MSQL       = data.aws_secretsmanager_secret.db_logging.arn
  }
}

resource "aws_ecs_task_definition" "task_definition_db_migration" {
  family                   = "${var.tags.ServiceName}-db-migration"
  container_definitions    = data.template_file.task_definition_db_migration.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  tags                     = var.tags
  task_role_arn            = var.task_role
  execution_role_arn       = var.task_execution_role
}
