module "ecr-nginx" {
  source = "git::https://github.m6web.fr/sysadmin/terraform-ecr.git?ref=v3.0.2"

  ecr-name               = "${var.project}-nginx-${var.customer}"
  ecr-push-and-pull-arns = var.ecr_write_arns
  ecr-pull-arns          = var.ecr_read_arns
  create                 = var.create_ecr
  project                = var.project
  team                   = var.team
  customer               = var.customer
  tenant                 = var.tenant
}

module "ecr-node" {
  source = "git::https://github.m6web.fr/sysadmin/terraform-ecr.git?ref=v3.0.2"

  ecr-name               = "${var.project}-node-${var.customer}"
  ecr-push-and-pull-arns = var.ecr_write_arns
  ecr-pull-arns          = var.ecr_read_arns
  create                 = var.create_ecr
  project                = var.project
  team                   = var.team
  customer               = var.customer
  tenant                 = var.tenant
}
