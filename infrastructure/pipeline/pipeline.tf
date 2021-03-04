module "codebuild" {
  source            = "./modules/codebuild/"
  account_name      = local.account_name
  secret_npm_token  = "/common/npm-token"
  aws_account_id    = local.aws_account_id
  deployer_role     = local.deployer_role
  environment       = local.environment
  environmentdeploy = local.environmentdeploy
  container_name    = "node"
  application_name  = "bulk-email"

  vpc_id     = data.aws_vpc.main.id
  subnet_ids = [for s in data.aws_subnet.private : s.id]
  tags       = module.common.tags
}

module "codepipeline" {
  source              = "./modules/codepipeline/"
  repo                = element(split("/", module.common.tags.Project), 1)
  owner               = element(split("/", module.common.tags.Project), 0)
  branch              = "feature/codepipeline" // this branh will trigger the  pipeline
  aws_account_id      = local.aws_account_id
  deployer_role       = local.deployer_role
  environmentdeploy   = local.environmentdeploy
  secret_github_token = data.aws_secretsmanager_secret_version.github_token.secret_string
  stage_build_name    = module.codebuild.codebuild_name
  tags                = module.common.tags
}

