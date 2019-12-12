module "codebuild_cicd_heavy" {
  source = "../codebuild-cicd/"

  name   = "heavy"
  create = var.create_codebuild_cicd

  environment_image            = "m6web-base"
  environment_m6web_base_image = "908538848727.dkr.ecr.eu-west-3.amazonaws.com/codebuild-m6web-base:20191015143554-origin-master"

  source_type     = "GITHUB_ENTERPRISE"
  source_location = var.source_location

  project     = var.project
  team        = var.team
  create_role = var.create_codebuild_role
  customer    = var.customer
  tenant      = var.tenant
}

module "codebuild_cicd_light" {
  source = "../codebuild-cicd/"

  name   = "light"
  create = var.create_codebuild_cicd

  environment_image = "aws"

  source_type = "NO_SOURCE"

  project     = var.project
  team        = var.team
  create_role = var.create_codebuild_role
  customer    = var.customer
  tenant      = var.tenant
}
