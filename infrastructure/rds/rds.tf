resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = replace(substr(join("-", [module.common.tags.Service, "aurora-db-parameter-group"]), 0, 255), "/-$/", "")
  family      = "aurora-mysql5.7"
  description = replace(substr(join("-", [module.common.tags.Service, "aurora-db-parameter-group"]), 0, 255), "/-$/", "")
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = replace(substr(join("-", [module.common.tags.Service, "cluster-parameter-group"]), 0, 255), "/-$/", "")
  family      = "aurora-mysql5.7"
  description = replace(substr(join("-", [module.common.tags.Service, "cluster-parameter-group"]), 0, 255), "/-$/", "")
}

module "aurora_db_cluster" {
  source = "./modules/rds-instances"

  subnet_group_name               = replace(substr(join("-", [module.common.tags.Service, "aurora-db"]), 0, 255), "/-$/", "")
  envname                         = local.environment
  subnets                         = data.aws_subnet_ids.private.ids
  identifier_prefix               = replace(substr(module.common.tags.Service, 0, 255), "/-$/", "")
  azs                             = [for s in data.aws_subnet.private : s.availability_zone]
  aws_vpc_id                      = data.aws_vpc.main.id
  final_snapshot_identifier       = replace(substr(join("-", [module.common.tags.Service, "final-db-snapshot"]), 0, 255), "/-$/", "")
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_57_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id
  instanceDetails                 = local.instanceDetails
  tags                            = module.common.tags
}

module "aurora_db_alarms" {
  source             = "./modules/rds-alarms"
  cw_alarms          = true
  cluster_identifier = module.aurora_db_cluster.cluster_identifier
  depends_on         = [ module.aurora_db_cluster ]
  tags               = module.common.tags
}
