module "bedrock_web_m6web" {
  source = "./bedrock-web/"

  customer                 = "m6web"
  tenant                   = "rtlmutu"
  create_s3_static_assets  = var.create_s3
  create_iam_static_assets = var.create_iam
  create_ecr               = var.create_ecr
  fastly_enabled           = var.fastly_enabled
  cloudfront_enabled       = var.cloudfront_enabled
  cdn_token                = var.cdn_token
  origin                   = lookup(var.origin, "rtlmutu", "")
  domain_name              = lookup(var.domain_name, "m6web", "")
  cdn_certificate          = lookup(data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1, terraform.workspace, "")
  web_acl_id               = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
  create_codebuild_cicd    = var.create_codebuild_cicd
  create_codebuild_role    = var.create_codebuild_role
}

output "cloudfront_m6web" {
  value = module.bedrock_web_m6web.domain_name
}

output "cloudfront_m6web_zone_id" {
  value = module.bedrock_web_m6web.zone_id
}

module "bedrock_web_rtlbe" {
  source = "./bedrock-web/"

  customer                 = "rtlbe"
  tenant                   = "rtlmutu"
  create_s3_static_assets  = var.create_s3
  create_iam_static_assets = var.create_iam
  create_ecr               = var.create_ecr
  cloudfront_enabled       = var.cloudfront_enabled
  cdn_token                = var.cdn_token
  origin                   = lookup(var.origin, "rtlmutu", "")
  domain_name              = lookup(var.domain_name, "rtlbe", "")
  cdn_certificate          = lookup(data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1, terraform.workspace, "")
  web_acl_id               = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
  create_codebuild_cicd    = var.create_codebuild_cicd
  create_codebuild_role    = var.create_codebuild_role
}

output "cloudfront_rtlbe" {
  value = module.bedrock_web_rtlbe.domain_name
}

output "cloudfront_rtlbe_zone_id" {
  value = module.bedrock_web_rtlbe.zone_id
}

module "bedrock_web_rtlhu" {
  source = "./bedrock-web/"

  customer                 = "rtlhu"
  tenant                   = "rtlmutu"
  create_s3_static_assets  = var.create_s3
  create_iam_static_assets = var.create_iam
  create_ecr               = var.create_ecr
  cloudfront_enabled       = var.cloudfront_enabled
  cdn_token                = var.cdn_token
  origin                   = lookup(var.origin, "rtlmutu", "")
  domain_name              = lookup(var.domain_name, "rtlhu", "")
  cdn_certificate          = lookup(data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1, terraform.workspace, "")
  web_acl_id               = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
  create_codebuild_cicd    = var.create_codebuild_cicd
  create_codebuild_role    = var.create_codebuild_role
}

output "cloudfront_rtlhu" {
  value = module.bedrock_web_rtlhu.domain_name
}

output "cloudfront_rtlhu_zone_id" {
  value = module.bedrock_web_rtlhu.zone_id
}

module "bedrock_web_rtlhr" {
  source = "./bedrock-web/"

  customer                 = "rtlhr"
  tenant                   = "rtlmutu"
  create_s3_static_assets  = var.create_s3
  create_iam_static_assets = var.create_iam
  create_ecr               = var.create_ecr
  cloudfront_enabled       = var.cloudfront_enabled
  cdn_token                = var.cdn_token
  origin                   = lookup(var.origin, "rtlmutu", "")
  domain_name              = lookup(var.domain_name, "rtlhr", "")
  cdn_certificate          = lookup(data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1, terraform.workspace, "")
  web_acl_id               = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
  create_codebuild_cicd    = var.create_codebuild_cicd
  create_codebuild_role    = var.create_codebuild_role
}

output "cloudfront_rtlhr" {
  value = module.bedrock_web_rtlhr.domain_name
}

output "cloudfront_rtlhr_zone_id" {
  value = module.bedrock_web_rtlhr.zone_id
}

module "bedrock_web_salto" {
  source = "./bedrock-web/"

  customer                 = "salto"
  tenant                   = "salto"
  create_s3_static_assets  = var.create_s3
  create_iam_static_assets = var.create_iam
  create_ecr               = var.create_ecr
  cdn_token                = var.cdn_token
  cloudfront_enabled       = var.cloudfront_enabled
  origin                   = lookup(var.origin, "salto", "")
  domain_name              = lookup(var.domain_name, "salto", "")
  cdn_certificate          = lookup(data.terraform_remote_state.certificates.outputs.acm_certificates_salto_fr_us_east_1, terraform.workspace, "")
  web_acl_id               = data.terraform_remote_state.security_acl.outputs.waf_acl_salto_only_allow_partners_id
  create_codebuild_cicd    = var.create_codebuild_cicd
  create_codebuild_role    = var.create_codebuild_role
}

output "cloudfront_salto" {
  value = module.bedrock_web_salto.domain_name
}

output "cloudfront_salto_zone_id" {
  value = module.bedrock_web_salto.zone_id
}
