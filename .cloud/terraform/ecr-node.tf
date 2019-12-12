module "ecr-node" {
  source = "git::https://github.m6web.fr/sysadmin/terraform-ecr.git?ref=v3.0.0"

  ecr-name               = "${var.project}-node"
  ecr-push-and-pull-arns = var.ecr_write_arns
  ecr-pull-arns          = var.ecr_read_arns
  create                 = var.create_ecr
  project                = var.project
  team                   = var.team
}

